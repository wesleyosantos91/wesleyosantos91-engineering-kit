#!/usr/bin/env bash
# Validate the MINIMUM context exists before implementation. Does NOT implement.
# Reads an optional task file ($1) or prints the checklist to fill. Idempotent.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

TASK_FILE="${1:-}"
REQUIRED=(
  "objetivo"
  "requisito"
  "spec OpenSpec (quando aplicável)"
  "SDD/plano técnico (quando aplicável)"
  "arquivos relevantes"
  "teste esperado"
  "tipo de teste (unit/integration/bdd)"
  "critério de pronto"
  "risco"
  "rollback"
)

section "OpenSpec / context check"
if [ -n "$TASK_FILE" ] && [ -f "$TASK_FILE" ]; then
  info "Validando contexto em: $TASK_FILE"
  missing=0
  for item in "${REQUIRED[@]}"; do
    key="${item%% *}"
    if grep -qiE "$key" "$TASK_FILE"; then ok "presente: $item"; else warn "AUSENTE: $item"; missing=$((missing+1)); fi
  done
  echo
  if [ "$missing" -gt 0 ]; then
    err "Contexto incompleto ($missing itens). NÃO implemente até completar."
    exit 2
  fi
  ok "Contexto mínimo OK. Pode prosseguir para o fluxo TDD."
else
  warn "Nenhum arquivo de tarefa informado. Preencha este checklist antes de implementar:"
  for item in "${REQUIRED[@]}"; do echo "  - [ ] $item"; done
  echo
  info "Uso: bash scripts/ai/opsx-context-check.sh <arquivo-da-tarefa.md>"
fi
