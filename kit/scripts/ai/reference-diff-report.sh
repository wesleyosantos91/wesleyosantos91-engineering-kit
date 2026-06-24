#!/usr/bin/env bash
# Compara a camada de agentes local com o repo de referência multi-agents (se
# clonado em REF_DIR) e gera .ai/reports/reference-diff-report.md. Read-only.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

REF_DIR="${REF_DIR:-/tmp/multi-agents-reference}"
OUT="$REPO_ROOT/.ai/reports/reference-diff-report.md"
mkdir -p "$(dirname "$OUT")"

local_agents() { find "$REPO_ROOT/.claude/agents" -maxdepth 1 -name '*.md' 2>/dev/null | sed 's#.*/##;s#\.md$##' | sort; }
ref_agents()   { find "$REF_DIR/claude-code/.claude/agents" -maxdepth 1 -name '*.md' 2>/dev/null | sed 's#.*/##;s#\.md$##' | sort; }

{
  echo "# Reference diff report (multi-agents)"
  echo
  echo "- gerado: $(now_utc)"
  echo "- referência: \`$REF_DIR\` (clone de wesleyosantos91/multi-agents)"
  echo

  if [ ! -d "$REF_DIR" ]; then
    echo "## Referência indisponível"
    echo "O clone não está presente em \`$REF_DIR\`. Rode:"
    echo '```bash'
    echo "git clone --depth 1 https://github.com/wesleyosantos91/multi-agents $REF_DIR"
    echo '```'
    echo "Relatório gerado com base apenas no estado local."
  else
    echo "## Agentes na referência"
    echo '```'
    ref_agents
    echo '```'
    echo "## Agentes escolhidos para este repo"
    echo '```'
    local_agents
    echo '```'
    echo "## Agentes ignorados (e motivo)"
    echo "Presentes na referência, NÃO adotados agora (fora do foco Java 25 / Claude+Codex):"
    echo '```'
    comm -23 <(ref_agents) <(local_agents) || true
    echo '```'
    echo "> Motivos e backlog: \`docs/ai-harness/agents-backlog.md\` e \`docs/ai-harness/reference-multi-agents.md\`."
  fi

  echo
  echo "## Commands aproveitados (.claude/commands novos)"
  echo '```'
  for c in agents spawn-review-team pre-pr arch-review qa-review security-check contract-review local-setup docs adr; do
    [ -f "$REPO_ROOT/.claude/commands/$c.md" ] && echo "$c"
  done
  echo '```'
  echo "## Skills aproveitadas (.claude/skills e .agents/skills)"
  echo '```'
  for d in "$REPO_ROOT"/.claude/skills/*/; do
    b="$(basename "$d")"
    case "$b" in openspec-*) ;; *) [ -f "$d/SKILL.md" ] && echo "$b";; esac
  done
  echo '```'
  echo "## References / templates criados"
  echo '```'
  find "$REPO_ROOT/.ai/references" "$REPO_ROOT/.ai/templates" -name '*.md' 2>/dev/null | sed "s#$REPO_ROOT/##" | sort
  echo '```'
  echo
  echo "## Riscos de divergência"
  echo "- Manter a referência como inspiração, não contrato. Em conflito, prevalece o harness local."
  echo "- Evitar reintroduzir agentes/skills de stacks não usadas (overengineering)."
} > "$OUT"

info "Relatório: ${OUT#"$REPO_ROOT/"}"
ok "reference-diff-report gerado."
