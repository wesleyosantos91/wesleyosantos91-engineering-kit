---
name: api-contract-review
description: Detecta breaking changes e valida versionamento/compatibilidade de contrato.
---

# Skill: api-contract-review

## Objetivo
Detecta breaking changes e valida versionamento/compatibilidade de contrato.

## Quando usar
Qualquer mudança de API (REST/Async/Avro/JSON Schema/GraphQL/gRPC).

## Quando NÃO usar
Mudança sem impacto em contrato.

## Inputs esperados
- Contrato/spec e código web/api.

## Workflow
1. Comparar contrato anterior x novo.
2. openspec-validate.sh.
3. Classificar compatível x breaking; checar idempotência e RFC 9457.

## Comandos permitidos
```bash
git diff
bash scripts/ai/openspec-validate.sh
```

## Saída esperada
Matriz de compatibilidade + decisão.

## Critérios de qualidade
- Breaking change sem versionamento/migração = NO-GO.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
