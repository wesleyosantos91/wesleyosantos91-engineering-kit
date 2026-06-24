#!/usr/bin/env bash
# EXEMPLO de hook (não ativo por padrão). Antes de implementar, exige contexto
# mínimo de OpenSpec/tarefa. Uso: PreToolUse(Edit/Write) em src/main.
# Recebe o arquivo de tarefa em $1; bloqueia (exit 2) se contexto incompleto.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
task="${1:-}"
if [ -z "$task" ] || [ ! -f "$task" ]; then
  echo "[hook] Aviso: nenhum arquivo de tarefa para validar contexto (ignorando)." >&2
  exit 0
fi
if bash "$ROOT/scripts/ai/opsx-context-check.sh" "$task" >/dev/null 2>&1; then
  exit 0
else
  echo "[hook] BLOQUEADO: contexto mínimo de OpenSpec/tarefa incompleto. Rode opsx-context-check.sh." >&2
  exit 2
fi
