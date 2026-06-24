#!/usr/bin/env bash
# Validate OpenSpec/SDD presence and surface specs/changes. Compares, at a high
# level, referenced artifacts vs code. Does NOT invent requirements. Idempotent.
# Output: .ai/reports/openspec-check.md
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

OUT="$REPO_ROOT/.ai/reports/openspec-check.md"
mkdir -p "$(dirname "$OUT")"

OPENSPEC_DIR=""
for d in openspec .openspec specs docs/specs; do
  [ -d "$REPO_ROOT/$d" ] && { OPENSPEC_DIR="$REPO_ROOT/$d"; break; }
done

{
  echo "# OpenSpec / SDD validation"
  echo
  echo "- generated: $(now_utc)"
  echo "- branch: $(git_branch)  commit: $(git_commit)"
  echo

  if [ -z "$OPENSPEC_DIR" ]; then
    echo "## Status: AUSENTE"
    echo
    echo "Nenhum diretório OpenSpec/SDD encontrado (\`openspec/\`, \`.openspec/\`, \`specs/\`, \`docs/specs/\`)."
    echo "Não foram inventados requisitos. Use \`docs/ai-harness/openspec-sdd-flow.md\` para iniciar."
  else
    echo "## Status: PRESENTE"
    echo "- dir: \`${OPENSPEC_DIR#"$REPO_ROOT/"}\`"
    echo
    echo "### Specs"
    echo '```'
    find "$OPENSPEC_DIR" -type d -name specs -prune -exec find {} -type f \; 2>/dev/null | sed "s#$REPO_ROOT/##" | sort || true
    find "$OPENSPEC_DIR/specs" -type f 2>/dev/null | sed "s#$REPO_ROOT/##" | sort || true
    echo '```'
    echo "### Changes"
    echo '```'
    find "$OPENSPEC_DIR/changes" -maxdepth 2 -type f 2>/dev/null | sed "s#$REPO_ROOT/##" | sort || echo "(nenhuma change)"
    echo '```'
    echo
    echo "### Sinais de rastreabilidade (heurístico)"
    echo "- Endpoints declarados em specs:"
    echo '```'
    grep -rohiE '(GET|POST|PUT|PATCH|DELETE)\s+/[a-zA-Z0-9/_{}-]+' "$OPENSPEC_DIR" 2>/dev/null | sort -u | head -40 || echo "(nenhum)"
    echo '```'
    echo "- Endpoints no código (anotações Spring/JAX-RS):"
    echo '```'
    grep -rohiE '@(Get|Post|Put|Patch|Delete|Request)Mapping\([^)]*\)|@Path\([^)]*\)' src/main 2>/dev/null | sort -u | head -40 || echo "(nenhum)"
    echo '```'
    echo
    echo "> Comparação completa spec×código exige contexto da tarefa. Se a tarefa cita"
    echo "> uma change/spec, confronte os critérios de aceite antes de implementar."
  fi
} > "$OUT"

info "Relatório: ${OUT#"$REPO_ROOT/"}"
[ -n "$OPENSPEC_DIR" ] && ok "OpenSpec detectado em ${OPENSPEC_DIR#"$REPO_ROOT/"}" || warn "OpenSpec ausente (documentado no relatório)"
