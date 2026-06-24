---
name: openspec-validation
description: Valida implementação contra OpenSpec/SDD/PRD e exige contexto mínimo.
---

# Skill: openspec-validation

## Objetivo
Valida implementação contra OpenSpec/SDD/PRD e exige contexto mínimo.

## Quando usar
Mudança de domínio/API; pré-PR.

## Quando NÃO usar
Tarefa sem spec relevante.

## Inputs esperados
- Arquivo da tarefa/change.
- Spec/PRD relacionados.

## Workflow
1. opsx-context-check.sh <tarefa>.
2. openspec-validate.sh.
3. Confrontar endpoints/eventos/regras spec x código.
4. Registrar gaps.

## Comandos permitidos
```bash
bash scripts/ai/opsx-context-check.sh
bash scripts/ai/openspec-validate.sh
```

## Saída esperada
Relatório de gaps (.ai/reports/openspec-check.md) + decisão prosseguir/bloquear.

## Critérios de qualidade
- Não inventar requisitos.
- Requisito não claro -> NO-GO.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
