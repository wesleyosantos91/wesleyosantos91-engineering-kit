#!/usr/bin/env bash
set -euo pipefail

NPM_PREFIX="${NPM_PREFIX:-$HOME/.npm-global}"
PIPX_BIN="$HOME/.local/bin"

# Java, Node and Python are provided by devcontainer features (see
# devcontainer.json), which pin tool versions independently of the base image
# distro, so we do NOT apt-install them here (apt versions vary per distro and
# can be too old). Maven is provided by the project's ./mvnw wrapper, which pins
# the exact version the build needs and is fully host/OS-agnostic. We only
# install the few extras the features don't cover.
sudo apt-get update
sudo apt-get install -y curl ca-certificates

mkdir -p "$NPM_PREFIX/bin"
npm config set prefix "$NPM_PREFIX" >/dev/null

add_path_to_profile() {
  local profile_file="$1"

  if ! grep -q 'CLI bins for devcontainer tools' "$profile_file" 2>/dev/null; then
    {
      echo ''
      echo '# CLI bins for devcontainer tools'
      echo "export PATH=\"$NPM_PREFIX/bin:$PIPX_BIN:\$PATH\""
    } >> "$profile_file"
  fi
}

add_path_to_profile "$HOME/.profile"
add_path_to_profile "$HOME/.zshrc"

export PATH="$NPM_PREFIX/bin:$PIPX_BIN:$PATH"

install_uv() {
  if command -v uv >/dev/null 2>&1 && command -v uvx >/dev/null 2>&1; then
    echo "uv already installed"
    return 0
  fi

  echo "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
}

install_npm_global() {
  local package_name="$1"

  if [ -z "$package_name" ]; then
    return 0
  fi

  echo "Installing npm global package: $package_name"
  npm install --global "$package_name"
}

install_rtk() {
  if command -v rtk >/dev/null 2>&1; then
    echo "RTK already installed"
    return 0
  fi

  echo "Installing RTK"
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh -o /tmp/rtk-install.sh
  sh /tmp/rtk-install.sh
}

run_project_init() {
  local marker_path="$1"
  local command_line="$2"
  local tool_name="$3"

  if [ -e "$marker_path" ]; then
    echo "$tool_name already initialized: $marker_path"
    return 0
  fi

  echo "Initializing $tool_name in repository"
  if ! bash -lc "$command_line"; then
    echo "Could not initialize $tool_name with: $command_line"
    echo "Set the corresponding *_INIT_COMMAND variable if this CLI uses a different command."
  fi
}

codex_mcp_exists() {
  local name="$1"
  codex mcp get "$name" >/dev/null 2>&1
}

configure_codex_mcp_stdio() {
  local name="$1"
  shift

  if codex_mcp_exists "$name"; then
    echo "Codex MCP already registered: $name"
    return 0
  fi

  echo "Registering Codex MCP: $name"
  codex mcp add "$name" -- "$@" || echo "Could not register Codex MCP: $name"
}

configure_codex_mcp_url() {
  local name="$1"
  local url="$2"

  if codex_mcp_exists "$name"; then
    echo "Codex MCP already registered: $name"
    return 0
  fi

  echo "Registering Codex MCP: $name"
  codex mcp add "$name" --url "$url" || echo "Could not register Codex MCP: $name"
}

configure_codex_mcps() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "Codex CLI not found; skipping Codex MCP registration"
    return 0
  fi

  if [ ! -d "scripts/mcp" ]; then
    echo "scripts/mcp not found; skipping Codex MCP registration"
    return 0
  fi

  configure_codex_mcp_stdio context7 bash scripts/mcp/context7.sh
  configure_codex_mcp_stdio springdocs bash scripts/mcp/springdocs.sh
  configure_codex_mcp_stdio aws-docs bash scripts/mcp/aws-docs.sh
  configure_codex_mcp_stdio terraform-registry bash scripts/mcp/terraform-registry.sh
  configure_codex_mcp_stdio aws-pricing-sandbox bash scripts/mcp/aws-pricing-sandbox.sh
  configure_codex_mcp_stdio localstack-lab bash scripts/mcp/localstack.sh
}

# AI coding CLIs
install_uv
install_npm_global "${CODEX_NPM_PACKAGE:-@openai/codex}"
install_npm_global "${CLAUDE_CODE_NPM_PACKAGE:-@anthropic-ai/claude-code}"

# Spec/API and repository context tools.
install_npm_global "${OPEN_SPEC_NPM_PACKAGE:-@fission-ai/openspec@latest}"
install_rtk
install_npm_global "${REPOMIX_NPM_PACKAGE:-repomix}"

run_project_init "${OPEN_SPEC_MARKER:-openspec}" "${OPEN_SPEC_INIT_COMMAND:-openspec init --tools codex,claude --force}" "OpenSpec"

# Initialize RTK globally for both Codex and Claude Code. RTK does not create the
# parent config dirs, and --auto-patch is incompatible with --codex.
echo "Initializing RTK (global) for Codex and Claude Code"
mkdir -p "$HOME/.codex" "$HOME/.claude"
rtk init -g --codex </dev/null || echo "Could not run: rtk init -g --codex"
rtk init -g --auto-patch </dev/null || echo "Could not run: rtk init -g"
configure_codex_mcps

# Repomix runs fine without a config (sensible defaults) and `repomix --init` is
# interactive (can't be scripted reliably in postCreate), so write a default
# config directly if one isn't already present.
if [ -e "repomix.config.json" ]; then
  echo "Repomix already initialized: repomix.config.json"
else
  echo "Creating repomix.config.json"
  cat > repomix.config.json <<'JSON'
{
  "$schema": "https://repomix.com/schemas/latest/schema.json",
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "fileSummary": true,
    "directoryStructure": true,
    "removeComments": false,
    "showLineNumbers": false
  },
  "include": [],
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": []
  },
  "security": {
    "enableSecurityCheck": true
  }
}
JSON
fi

# Ensure the Docker-in-Docker daemon is up. This is OS-agnostic: on most hosts
# (Docker Desktop on Windows/macOS, typical Linux) the feature already started a
# healthy daemon and we leave it untouched. We only intervene when it failed to
# start, and only fall back to the nftables iptables backend if the default
# backend can't create the NAT table (host kernels that use nft, e.g. RHEL).
restart_dockerd() {
  sudo pkill dockerd >/dev/null 2>&1 || true
  sleep 2
  sudo bash -c 'nohup dockerd >/tmp/dockerd.log 2>&1 &'
  sleep 5
}

configure_docker_daemon() {
  command -v docker >/dev/null 2>&1 || return 0

  # Already healthy (the common case on every supported host): do nothing.
  if docker ps >/dev/null 2>&1; then
    echo "Docker daemon running"
    return 0
  fi

  echo "Docker daemon not ready; attempting to start it with the default backend"
  restart_dockerd
  if docker ps >/dev/null 2>&1; then
    echo "Docker daemon running"
    return 0
  fi

  # Fallback only for hosts whose kernel uses nftables and where the legacy
  # iptables backend fails to create the NAT chains.
  if grep -qiE "iptables.*(nat|table).*(does not exist|failed)" /tmp/dockerd.log 2>/dev/null; then
    echo "NAT table error detected; switching iptables to the nft backend and retrying"
    sudo update-alternatives --set iptables /usr/sbin/iptables-nft >/dev/null 2>&1 || true
    sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-nft >/dev/null 2>&1 || true
    restart_dockerd
  fi

  if docker ps >/dev/null 2>&1; then
    echo "Docker daemon running"
  else
    echo "WARNING: Docker daemon not running; check /tmp/dockerd.log"
  fi
}
configure_docker_daemon

echo "Devcontainer tools installed."
