#!/usr/bin/env bash
# EXEMPLO de hook (não ativo por padrão). Após editar Java, roda format-check.
# Uso: PostToolUse(Edit/Write). Não falha a sessão; apenas avisa.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
if bash "$ROOT/scripts/quality/format-check.sh" >/dev/null 2>&1; then
  echo "[hook] format-check OK"
else
  echo "[hook] format-check apontou diferenças — rode: bash scripts/quality/format.sh" >&2
fi
exit 0
