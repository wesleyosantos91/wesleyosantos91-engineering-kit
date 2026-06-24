# Prompt (Codex): plan

Objetivo: diagnosticar e planejar, **sem editar código**.

1. Rode read-only: `bash scripts/ai/preflight.sh`, `bash scripts/ai/detect-project.sh`,
   `bash scripts/ai/openspec-validate.sh`.
2. Leia a tarefa e confirme contexto: `bash scripts/ai/opsx-context-check.sh <arquivo>`.
3. Entregue um plano curto: objetivo, requisito (spec/OpenSpec), arquivos prováveis
   por camada, estratégia de teste (unit obrigatório; integration se houver dependência
   externa; BDD se houver regra de negócio), critério de pronto testável, riscos, rollback.
4. Não implemente; aguarde confirmação.

Regras: `AGENTS.md`, `.ai/rules/architecture.md`, `.ai/rules/openspec-sdd.md`,
`.ai/rules/token-economy.md`. Não invente requisitos.
