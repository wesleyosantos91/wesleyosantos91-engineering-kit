---
description: Analisa um erro com contexto mínimo, preservando o stack trace.
---

# /debug

Analise o erro descrito em $ARGUMENTS.

## Princípios
- Use **modo conciso** e contexto cirúrgico (`.ai/rules/token-economy.md`).
- **Preserve o stack trace relevante** por inteiro; resuma o resto do log.
- Não vaze secrets nos logs (`.ai/rules/security.md`).

## Passos
1. Capture o stack trace e identifique a causa raiz (não só o sintoma).
2. Localize o arquivo/linha relevante.
3. **Reproduza com um teste falhando** antes de corrigir (TDD de bugfix).
4. Proponha a correção mínima.
5. Prove com o teste passando: `bash scripts/quality/test-unit.sh`.
6. Adicione teste de regressão.

## Saída
Causa raiz + correção + teste de regressão. Não rode comandos destrutivos.
