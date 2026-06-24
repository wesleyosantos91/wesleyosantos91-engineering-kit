#!/usr/bin/env bash
# Relatório do time de agentes: lista agentes Claude/Codex, skills e a matriz de
# seleção. Read-only. Output: .ai/reports/agent-team-report.md
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

OUT="$REPO_ROOT/.ai/reports/agent-team-report.md"
mkdir -p "$(dirname "$OUT")"

list_names() { # list_names <glob> <ext>
  find "$1" -maxdepth 1 -name "*.$2" 2>/dev/null | sed "s#.*/##;s#\.$2\$##" | sort || true
}

{
  echo "# Agent team report"
  echo
  echo "- gerado: $(now_utc)"
  echo
  echo "## Agentes Claude (.claude/agents)"
  for n in $(list_names "$REPO_ROOT/.claude/agents" md); do echo "- $n"; done
  echo
  echo "## Agentes Codex (.codex/agents)"
  for n in $(list_names "$REPO_ROOT/.codex/agents" toml); do echo "- $n"; done
  echo
  echo "## Skills (Claude / Codex)"
  for d in "$REPO_ROOT"/.claude/skills/*/; do [ -f "$d/SKILL.md" ] && echo "- $(basename "$d")"; done
  echo
  echo "## Matriz de seleção"
  echo
  if [ -f "$REPO_ROOT/.ai/references/agent-selection-matrix.md" ]; then
    sed -n '/^|/p' "$REPO_ROOT/.ai/references/agent-selection-matrix.md"
  else
    echo "_(.ai/references/agent-selection-matrix.md ausente)_"
  fi
} > "$OUT"

cat "$OUT"
echo
ok "agent team report: ${OUT#"$REPO_ROOT/"}"
