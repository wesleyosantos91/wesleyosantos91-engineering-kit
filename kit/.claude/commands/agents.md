---
description: Lista os agentes do harness e quando acioná-los.
---

# /agents

**Objetivo:** descobrir os agentes disponíveis e a matriz de seleção.

**Quando usar:** ao planejar uma tarefa e decidir quem acionar.

**Agentes envolvidos:** nenhum (apenas catálogo).

**Comandos shell permitidos:**
```bash
ls .claude/agents/
cat .ai/references/agent-selection-matrix.md
bash scripts/ai/agent-team-report.sh
```

**Entradas esperadas:** nenhuma (ou o tipo de demanda).

**Saída esperada:** lista de agentes + recomendação de quais acionar para a demanda.

**Critério de pronto:** o usuário sabe quais agentes usar e por quê.

## Contexto adicional
$ARGUMENTS
