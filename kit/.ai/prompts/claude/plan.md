# Prompt (Claude): plan

> Equivalente operacional de `.claude/commands/plan.md`. Use quando invocar fora do slash command.

Diagnostique e planeje **sem editar código**.

1. Read-only: `bash scripts/ai/preflight.sh`, `bash scripts/ai/detect-project.sh`,
   `bash scripts/ai/openspec-validate.sh`.
2. Confirme contexto: `bash scripts/ai/opsx-context-check.sh <arquivo>`.
3. Plano curto: objetivo, requisito (spec/OpenSpec), arquivos prováveis por camada,
   estratégia de teste (unit obrigatório; integration se dependência externa; BDD se
   regra de negócio), critério de pronto testável, riscos, rollback.
4. Não implemente; aguarde confirmação.

Regras: `CLAUDE.md`, `.ai/rules/architecture.md`, `.ai/rules/openspec-sdd.md`,
`.ai/rules/token-economy.md`.
