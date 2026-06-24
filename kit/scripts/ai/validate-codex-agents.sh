#!/usr/bin/env bash
# Valida os agentes Codex (.codex/agents/*.toml): campos mínimos.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

DIR="$REPO_ROOT/.codex/agents"
section "Validando agentes Codex"
[ -d "$DIR" ] || { warn "Diretório $DIR não existe."; exit 0; }

fail=0; count=0
for f in "$DIR"/*.toml; do
  [ -e "$f" ] || continue
  count=$((count+1))
  name="$(basename "$f" .toml)"
  grep -qE '^name[[:space:]]*=' "$f"                 || { err "$name: falta name"; fail=$((fail+1)); }
  grep -qE '^description[[:space:]]*=' "$f"          || { err "$name: falta description"; fail=$((fail+1)); }
  grep -qE '^sandbox_mode[[:space:]]*=' "$f"         || { err "$name: falta sandbox_mode"; fail=$((fail+1)); }
  grep -qE '^developer_instructions[[:space:]]*=' "$f" || { err "$name: falta developer_instructions"; fail=$((fail+1)); }
  # triple-quoted block deve abrir e fechar
  if [ "$(grep -c '"""' "$f")" -lt 2 ]; then err "$name: bloco \"\"\" não fechado"; fail=$((fail+1)); fi
  ok "$name"
done

echo
info "Total: $count agente(s)."
if [ "$fail" -gt 0 ]; then err "Falhas de validação: $fail"; exit 1; fi
ok "Agentes Codex válidos."
