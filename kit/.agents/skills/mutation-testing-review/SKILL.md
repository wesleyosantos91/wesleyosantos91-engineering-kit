---
name: mutation-testing-review
description: Roda PIT e analisa mutantes sobreviventes (meta 90%).
---

# Skill: mutation-testing-review

## Objetivo
Roda PIT e analisa mutantes sobreviventes (meta 90%).

## Quando usar
Avaliar robustez dos testes; após atingir cobertura.

## Quando NÃO usar
Projeto ainda sem código de negócio mutável.

## Inputs esperados
- Módulo/classe alvo.

## Workflow
1. mutation-test.sh.
2. Ler pit-reports; listar SURVIVED.
3. Propor teste que mate cada mutante (domain = crítico).

## Comandos permitidos
```bash
bash scripts/quality/mutation-test.sh
```

## Saída esperada
Lista de mutantes sobreviventes + testes propostos.

## Critérios de qualidade
- Meta 90%; não mascarar com exclusões abusivas.
- Mutantes em domain são críticos.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
