#!/usr/bin/env bash
# Generate an economical context pack for the agent. Uses repomix if available,
# otherwise a manual fallback. Output: .ai/reports/context-pack.md. Idempotent.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

OUT="$REPO_ROOT/.ai/reports/context-pack.md"
mkdir -p "$(dirname "$OUT")"

EXCLUDE_DIRS=(target build .git .idea .vscode node_modules dist .gradle)
EXCLUDE_GLOBS=(".env" "*.pem" "*.key" "*.p12" "*.jks" "*.log" "*.jar" "*.class" "*.png" "*.jpg" "*.zip")

if command -v repomix >/dev/null 2>&1; then
  info "repomix detectado — gerando pack comprimido"
  # --compress reduces tokens; repomix.config.json already enables security check.
  if repomix --compress --quiet --output "$OUT" 2>/dev/null; then
    ok "context pack: $OUT (repomix --compress)"
    exit 0
  fi
  warn "repomix falhou; usando fallback manual"
fi

info "Fallback manual (sem repomix)"
{
  echo "# Context Pack (fallback)"
  echo
  echo "- generated: $(now_utc)"
  echo "- branch: $(git_branch)  commit: $(git_commit)"
  echo
  echo "## Tree (depth 3, filtrado)"
  echo '```'
  find "$REPO_ROOT" -maxdepth 3 -type f \
    $(printf ' -not -path */%s/*' "${EXCLUDE_DIRS[@]}") \
    | sed "s#$REPO_ROOT/##" | sort | head -300
  echo '```'
  echo
  echo "## Build file"
  if [ -n "${BUILD_FILE:-}" ]; then
    detect_build_tool
    echo '```xml'
    sed -n '1,200p' "$BUILD_FILE"
    echo '```'
  fi
} > "$OUT"
ok "context pack: $OUT (fallback). Exclusões: ${EXCLUDE_DIRS[*]} ${EXCLUDE_GLOBS[*]}"
