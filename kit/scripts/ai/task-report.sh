#!/usr/bin/env bash
# Generate the final task traceability report. Aggregates plan, diff, commands,
# tests, coverage, mutation, archunit, openspec. Idempotent.
# Output: .ai/reports/task-report.md  (or $1)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

OUT="${1:-$REPO_ROOT/.ai/reports/task-report.md}"
mkdir -p "$(dirname "$OUT")"
detect_build_tool; detect_java_version; detect_framework

read_report() { [ -f "$1" ] && { echo; echo "<details><summary>$2</summary>"; echo; echo '```'; sed -n '1,120p' "$1"; echo '```'; echo; echo "</details>"; } || echo "_($2: não gerado)_"; }

{
  echo "# Task report"
  echo
  echo "- generated: $(now_utc)"
  echo "- branch: $(git_branch)  commit: $(git_commit)"
  echo "- build tool: ${BUILD_TOOL} | java: ${JAVA_VERSION_CONFIGURED} | framework: ${FRAMEWORK}"
  echo
  echo "## 1. Objetivo"
  echo "_(preencher: o que esta tarefa entrega)_"
  echo
  echo "## 2. Plano"
  echo "_(preencher: passos planejados)_"
  echo
  echo "## 3. Arquivos alterados"
  echo '```'
  if is_git_repo; then git status --short; echo; git diff --stat 2>/dev/null | tail -40; else echo "(repo não-git: liste manualmente)"; fi
  echo '```'
  echo
  echo "## 4. Comandos executados"
  echo "_(preencher: comandos rodados durante a tarefa)_"
  echo
  echo "## 5. Resultados de qualidade"
  read_report "$REPO_ROOT/.ai/reports/quality-summary.md" "quality-summary"
  read_report "$REPO_ROOT/.ai/reports/openspec-check.md" "openspec-check"
  echo
  echo "## 6. Riscos / pendências / próximos passos"
  echo "_(preencher)_"
} > "$OUT"

ok "task report: ${OUT#"$REPO_ROOT/"}"
