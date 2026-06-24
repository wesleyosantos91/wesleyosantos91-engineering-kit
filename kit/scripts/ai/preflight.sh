#!/usr/bin/env bash
# Pre-task preflight: repo state, branch, modified files, apparent secrets,
# and a project summary. Read-only. Never edits files.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

section "Git"
if is_git_repo; then
  info "branch : $(git_branch)"
  info "commit : $(git_commit)"
  info "modified files:"
  git status --short || true
else
  warn "Não é um repositório git (rastreabilidade de diff/commit ficará limitada)."
fi

section "Apparent secrets scan (heurístico, read-only)"
# Best-effort grep for obvious secret patterns in tracked source/config.
secret_re='(AKIA[0-9A-Z]{16}|aws_secret_access_key|-----BEGIN [A-Z ]*PRIVATE KEY-----|password\s*=\s*["'"'"'][^"'"'"']{6,}|token\s*[:=]\s*["'"'"'][A-Za-z0-9_\-]{16,})'
hits="$(grep -rInE "$secret_re" \
        --exclude-dir=.git --exclude-dir=target --exclude-dir=build \
        --exclude-dir=node_modules --exclude-dir=.idea \
        --exclude='*.example' \
        --exclude='preflight.sh' --exclude='security.md' \
        "$REPO_ROOT" 2>/dev/null | head -20 || true)"
if [ -n "$hits" ]; then
  warn "Possíveis secrets encontrados — REVISE antes de continuar:"
  # Mask the value side; show only file:line and the key.
  echo "$hits" | sed -E 's/(=|:)\s*.*/\1 [REDACTED]/' | sed "s#$REPO_ROOT/##"
else
  ok "Nenhum secret aparente detectado."
fi

section "Project summary"
"$(dirname "${BASH_SOURCE[0]}")/detect-project.sh" | sed -n '1,200p'

echo
ok "preflight done — nenhum arquivo foi alterado"
