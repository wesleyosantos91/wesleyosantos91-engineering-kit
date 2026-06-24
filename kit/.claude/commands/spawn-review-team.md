---
description: Aciona um time mínimo de review via orquestrador.
---

# /spawn-review-team

**Objetivo:** montar um time de review proporcional à demanda.

**Quando usar:** review de mudança não trivial.

**Agentes envolvidos:** `staff-engineer-orchestrator` (faz triage e aciona os demais).

**Comandos shell permitidos:**
```bash
git diff
bash scripts/ai/preflight.sh
bash scripts/ai/agent-team-report.sh
```

**Entradas esperadas:** descrição da mudança / diff alvo.

**Saída esperada:** achados consolidados por severidade + GO/NO-GO.

**Critério de pronto:** time mínimo acionado (não todos), conflitos resolvidos, decisão emitida.

## Contexto adicional
$ARGUMENTS
