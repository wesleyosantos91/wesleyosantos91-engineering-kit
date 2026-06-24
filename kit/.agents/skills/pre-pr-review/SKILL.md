---
name: pre-pr-review
description: Checklist técnico final antes de abrir PR (GO/NO-GO).
---

# Skill: pre-pr-review

## Objetivo
Checklist técnico final antes de abrir PR (GO/NO-GO).

## Quando usar
Antes de abrir/atualizar PR.

## Quando NÃO usar
Loop de desenvolvimento (use java-quality-gate).

## Inputs esperados
- Diff/branch alvo.

## Workflow
1. Diff analysis.
2. openspec-validate.sh.
3. verify-all.sh --fast.
4. Varredura de secrets (preflight.sh).
5. Consolidar GO/NO-GO.

## Comandos permitidos
```bash
git diff
bash scripts/ai/preflight.sh
bash scripts/ai/openspec-validate.sh
bash scripts/quality/verify-all.sh --fast
```

## Saída esperada
Relatório GO/NO-GO por item (.ai/templates/pre-pr-checklist.md).

## Critérios de qualidade
- Gates verdes ou justificados; sem secrets; spec validada.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
