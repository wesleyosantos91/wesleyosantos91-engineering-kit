---
name: adr-generation
description: Gera um ADR (Architecture Decision Record) a partir do template.
---

# Skill: adr-generation

## Objetivo
Gera um ADR (Architecture Decision Record) a partir do template.

## Quando usar
Decisão arquitetural/tecnológica com impacto.

## Quando NÃO usar
Mudança trivial sem decisão relevante.

## Inputs esperados
- Decisão, contexto, alternativas, consequências.

## Workflow
1. Coletar contexto e alternativas.
2. Preencher .ai/templates/adr-template.md.
3. Salvar em docs/adr/NNNN-titulo.md.

## Comandos permitidos
```bash
ls docs/adr/ 2>/dev/null || true
```

## Saída esperada
Novo ADR com status/contexto/decisão/consequências.

## Critérios de qualidade
- Decisão rastreável; sem regra de negócio inventada.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
