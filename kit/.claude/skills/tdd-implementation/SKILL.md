---
name: tdd-implementation
description: Implementa feature/bugfix via TDD obrigatório (teste falhando -> mínimo -> refatora -> gates).
---

# Skill: tdd-implementation

## Objetivo
Implementa feature/bugfix via TDD obrigatório (teste falhando -> mínimo -> refatora -> gates).

## Quando usar
Implementação com spec clara; correção de bug.

## Quando NÃO usar
Requisito ambíguo (bloquear e validar spec antes).

## Inputs esperados
- Requisito/critério de aceite testável.
- Arquivos/camada alvo.

## Workflow
1. Teste falhando.
2. test-unit.sh (confirmar red).
3. Implementação mínima -> verde.
4. Refatorar.
5. verify-all.sh --fast.
6. task-report.sh.

## Comandos permitidos
```bash
bash scripts/quality/test-unit.sh
bash scripts/quality/verify-all.sh --fast
bash scripts/ai/task-report.sh
```

## Saída esperada
Diff + teste(s) + .ai/reports/task-report.md.

## Critérios de qualidade
- Nenhuma produção antes do teste falhando.
- Respeitar camadas; domínio sem tecnologia.
- Não alterar pom com risco nem thresholds.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
