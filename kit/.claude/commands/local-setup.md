---
description: Preparar/validar o ambiente local (DevContainer).
---

# /local-setup

**Objetivo:** garantir ambiente reproduzível para rodar e testar.

**Quando usar:** primeiro setup, problemas de ambiente, mudança no DevContainer.

**Agentes envolvidos:** `devcontainer-engineer`, `context-engineer`.

**Comandos shell permitidos:**
```bash
bash scripts/ai/detect-project.sh
./mvnw -v
docker --version
```

**Entradas esperadas:** sintoma/objetivo do setup.

**Saída esperada:** diagnóstico do ambiente + passos (sem alterar DevContainer sem aprovação).

**Critério de pronto:** `./mvnw -q -DskipTests package` roda no ambiente.

## Contexto adicional
$ARGUMENTS
