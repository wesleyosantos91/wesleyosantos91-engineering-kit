---
name: package-architecture-review
description: Revisa arquitetura/organização de pacotes, SOLID e isolamento do domínio.
---

# Skill: package-architecture-review

## Objetivo
Revisa arquitetura/organização de pacotes, SOLID e isolamento do domínio.

## Quando usar
Mudança de domínio/estrutura.

## Quando NÃO usar
Mudança sem impacto arquitetural.

## Inputs esperados
- Pacotes/arquivos alvo.

## Workflow
1. package-rules.sh (fallback grep/find).
2. archunit.sh (se houver teste de arquitetura).
3. Classificar violações por severidade.

## Comandos permitidos
```bash
bash scripts/quality/package-rules.sh
bash scripts/quality/archunit.sh
```

## Saída esperada
Lista de violações com evidência arquivo:linha.

## Critérios de qualidade
- domain sem Spring/JPA/AWS/Kafka/web/infra.
- SOLID obrigatório (`.ai/rules/solid.md`): SRP/OCP/LSP/ISP/DIP, sem abstração prematura.
- Não reestruturar pacotes sem aprovação.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
