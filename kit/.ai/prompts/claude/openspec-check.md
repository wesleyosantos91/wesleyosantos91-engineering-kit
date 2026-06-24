# Prompt (Claude): openspec-check

> Equivalente de `.claude/commands/openspec-check.md`.

1. `bash scripts/ai/openspec-validate.sh` → `.ai/reports/openspec-check.md`.
2. Confronte endpoints/eventos/comandos/regras da spec vs código e testes.
3. Aponte divergências spec×código.
4. Requisito não claro → bloqueie e peça spec. **Não invente requisitos**
   (`.ai/rules/openspec-sdd.md`). Sem OpenSpec → documente ausência e use o template.
