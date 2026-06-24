---
description: Implementa uma tarefa seguindo TDD obrigatório.
---

# /implement-tdd

Implemente a tarefa em $ARGUMENTS seguindo **TDD obrigatório** (`.ai/rules/tdd.md`).

## Fluxo (não pule etapas)

```text
1. entender requisito (spec/OpenSpec)
2. escrever TESTE FALHANDO
3. rodar: bash scripts/quality/test-unit.sh   (confirmar que falha)
4. implementar o MÍNIMO para passar
5. rodar testes (verde)
6. refatorar mantendo verde
7. bash scripts/quality/verify-all.sh --fast
8. bash scripts/ai/task-report.sh
```

Para bugfix: reproduza com teste falhando → corrija → prove com teste passando →
adicione regressão.

## Regras
- **Nenhuma** linha de produção antes de um teste falhando.
- Respeite camadas/pacotes (`.ai/rules/architecture.md`).
- Domínio sem Spring/JPA/AWS/Kafka.
- Não altere `pom.xml` com risco de quebra — proponha via `config/pom-quality-plugins.example.xml`.
- Não rode comandos destrutivos (`.ai/rules/security.md`).
- Não delete arquivos existentes; não reestruture pacotes sem aprovação.

## Saída
Diff claro + relatório em `.ai/reports/task-report.md`.
