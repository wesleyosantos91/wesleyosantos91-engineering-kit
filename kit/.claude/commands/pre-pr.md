---
description: Checklist completo antes de abrir PR (GO/NO-GO).
---

# /pre-pr

**Objetivo:** validar a mudança antes do PR.

**Quando usar:** antes de abrir/atualizar um PR.

**Agentes envolvidos (via orquestrador):** `context-engineer`, `java-architect`, `test-architect`, `security-reviewer`, `openspec-reviewer`, `quality-gate-engineer` (+ `api-contract-reviewer` se houver mudança de contrato).

**Comandos shell permitidos:**
```bash
git diff
bash scripts/ai/openspec-validate.sh
bash scripts/quality/verify-all.sh --fast
bash scripts/ai/task-report.sh
```

**Entradas esperadas:** diff/branch alvo.

**Saída esperada:** relatório GO/NO-GO por item (use `.ai/templates/pre-pr-checklist.md`).

**Critério de pronto:** gates verdes (ou justificados), sem secrets, spec validada, decisão final.

## Contexto adicional
$ARGUMENTS
