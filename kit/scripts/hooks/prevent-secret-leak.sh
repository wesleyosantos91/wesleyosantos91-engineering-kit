#!/usr/bin/env bash
# EXEMPLO de hook (não ativo por padrão). Bloqueia conteúdo/arquivo com secrets.
# Uso: PreToolUse(Write/Edit) ou pre-commit. Lê arquivo em $1 (ou stdin).
set -euo pipefail

target="${1:-}"
secret_re='(AKIA[0-9A-Z]{16}|aws_secret_access_key|-----BEGIN [A-Z ]*PRIVATE KEY-----|password[[:space:]]*=[[:space:]]*["'"'"'][^"'"'"']{6,}|token[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_\-]{16,})'

content="$( [ -n "$target" ] && [ -f "$target" ] && cat "$target" || cat )"
if printf '%s' "$content" | grep -qiE "$secret_re"; then
  echo "[hook] BLOQUEADO: possível secret detectado${target:+ em $target}." >&2
  exit 2
fi
exit 0
