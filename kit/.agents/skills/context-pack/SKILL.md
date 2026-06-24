---
name: context-pack
description: Empacota contexto econômico do repo para alimentar os agentes.
---

# Skill: context-pack

## Objetivo
Empacota contexto econômico do repo para alimentar os agentes.

## Quando usar
Início de tarefa grande; pré-PR.

## Quando NÃO usar
Tarefa pequena com contexto óbvio.

## Inputs esperados
- Escopo/arquivos relevantes.

## Workflow
1. context-pack.sh (repomix --compress; fallback manual).
2. Selecionar apenas o relevante.
3. Resumir logs mantendo stack trace.

## Comandos permitidos
```bash
bash scripts/ai/context-pack.sh
```

## Saída esperada
Pacote enxuto (.ai/reports/context-pack.md).

## Critérios de qualidade
- Preservar headroom; excluir binários/.env/chaves; nunca vazar secrets.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
