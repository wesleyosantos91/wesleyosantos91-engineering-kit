#!/usr/bin/env bash
# Valida os agentes Claude (.claude/agents/*.md): frontmatter com name/description.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

DIR="$REPO_ROOT/.claude/agents"
section "Validando agentes Claude"
[ -d "$DIR" ] || { warn "Diretório $DIR não existe."; exit 0; }

fail=0; count=0
for f in "$DIR"/*.md; do
  [ -e "$f" ] || continue
  count=$((count+1))
  name="$(basename "$f" .md)"
  head -1 "$f" | grep -q '^---' || { err "$name: sem frontmatter (--- na linha 1)"; fail=$((fail+1)); continue; }
  grep -qE '^name:' "$f"        || { err "$name: falta 'name:'"; fail=$((fail+1)); }
  grep -qE '^description:' "$f" || { err "$name: falta 'description:'"; fail=$((fail+1)); }
  grep -qiE 'rm -rf|git reset --hard|terraform apply|kubectl delete' "$f" \
    && ! grep -qiE 'não|nunca|never|NO-GO|bloque' "$f" \
    && { warn "$name: cita comando destrutivo sem contexto de proibição (revisar)"; }
  [ "$fail" -eq 0 ] && ok "$name"
done

echo
info "Total: $count agente(s)."
if [ "$fail" -gt 0 ]; then err "Falhas de validação: $fail"; exit 1; fi
ok "Agentes Claude válidos."
