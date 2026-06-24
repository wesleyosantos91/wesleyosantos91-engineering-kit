---
name: java-quality-gate
description: Executa e interpreta os quality gates Java 25 (Spotless, Checkstyle, JaCoCo 90%, PIT 90%, ArchUnit).
---

# Skill: java-quality-gate

## Objetivo
Executa e interpreta os quality gates Java 25 (Spotless, Checkstyle, JaCoCo 90%, PIT 90%, ArchUnit).

## Quando usar
Antes de fechar tarefa/PR; ao validar qualidade de uma mudança.

## Quando NÃO usar
Quando só precisa rodar testes unitários (use tdd-implementation) ou validar spec (openspec-validation).

## Inputs esperados
- Branch/diff alvo.
- Escopo (módulo/classe) quando aplicável.

## Workflow
1. Rodar verify-all.sh --fast no loop; --full antes de fechar.
2. Para gate específico, rodar o script correspondente.
3. Gerar quality-summary.
4. Classificar: falha real (bloqueia) x ausente (reportar) x melhoria.

## Comandos permitidos
```bash
bash scripts/quality/verify-all.sh --fast
bash scripts/quality/verify-all.sh --full
bash scripts/quality/quality-summary.sh
```

## Saída esperada
Resumo dos gates (.ai/reports/quality-summary.md) + GO/NO-GO de qualidade.

## Critérios de qualidade
- Nunca relaxar thresholds (90%) para passar.
- Gate ausente != falha. Não esconder falhas: causa + correção.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
