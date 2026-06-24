#!/usr/bin/env bash
# EXEMPLO de hook (não ativo por padrão). Ao concluir tarefa, gera o resumo.
# Uso: Stop/SubagentStop. Não bloqueia.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
bash "$ROOT/scripts/quality/quality-summary.sh" >/dev/null 2>&1 || true
echo "[hook] quality-summary atualizado em .ai/reports/quality-summary.md"
exit 0
