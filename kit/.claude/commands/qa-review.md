---
description: Revisão de qualidade de testes e gates.
---

# /qa-review

**Objetivo:** avaliar testes, cobertura e mutação.

**Quando usar:** testes frágeis, gaps, antes de fechar tarefa.

**Agentes envolvidos:** `test-architect`, `quality-gate-engineer`.

**Comandos shell permitidos:**
```bash
bash scripts/quality/test-unit.sh
bash scripts/quality/jacoco.sh
bash scripts/quality/mutation-test.sh
bash scripts/quality/quality-summary.sh
```

**Entradas esperadas:** módulo/classe alvo.

**Saída esperada:** gaps de teste + mutantes sobreviventes + resumo de gates.

**Critério de pronto:** plano de testes para atingir 90% line/branch e 90% mutation.

## Contexto adicional
$ARGUMENTS
