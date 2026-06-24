#!/usr/bin/env bash
# Valida as skills (Claude .claude/skills/**/SKILL.md e Codex .agents/skills/**/SKILL.md):
# frontmatter + seções obrigatórias.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

REQUIRED_SECTIONS=("Quando usar" "Quando NÃO usar" "Inputs" "Workflow" "Comandos" "Saída esperada")
fail=0; count=0

validate_dir() {
  local base="$1" label="$2"
  [ -d "$base" ] || { warn "$label: diretório $base não existe."; return 0; }
  section "Validando skills ($label)"
  while IFS= read -r f; do
    local name; name="$(basename "$(dirname "$f")")"
    # Skills de ferramenta do OpenSpec têm formato próprio (gerenciadas externamente).
    case "$name" in
      openspec-explore|openspec-propose|openspec-apply-change|openspec-archive-change|openspec-sync-specs) continue ;;
    esac
    count=$((count+1))
    head -1 "$f" | grep -q '^---' || { err "$name: sem frontmatter"; fail=$((fail+1)); }
    grep -qE '^name:' "$f"        || { err "$name: falta name"; fail=$((fail+1)); }
    grep -qE '^description:' "$f" || { err "$name: falta description"; fail=$((fail+1)); }
    for s in "${REQUIRED_SECTIONS[@]}"; do
      grep -qiF "$s" "$f" || { err "$name: falta seção '$s'"; fail=$((fail+1)); }
    done
    grep -qiE 'destrutiv|nunca expor|secrets' "$f" || warn "$name: sem nota de segurança explícita"
    ok "$name"
  done < <(find "$base" -name SKILL.md | sort)
}

validate_dir "$REPO_ROOT/.claude/skills" "Claude"
validate_dir "$REPO_ROOT/.agents/skills" "Codex"

echo
info "Total: $count skill file(s)."
if [ "$fail" -gt 0 ]; then err "Falhas de validação: $fail"; exit 1; fi
ok "Skills válidas."
