# Prompt (Codex): debug

Analise o erro com contexto mínimo.

- Modo conciso; preserve o **stack trace relevante** inteiro, resuma o resto.
- Não vaze secrets (`.ai/rules/security.md`).

Passos: identificar causa raiz → localizar arquivo/linha → **reproduzir com teste
falhando** → correção mínima → provar com `bash scripts/quality/test-unit.sh` →
adicionar regressão.

Saída: causa raiz + correção + teste de regressão. Sem comandos destrutivos.
