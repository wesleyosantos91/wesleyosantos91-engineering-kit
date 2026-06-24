# Índice de PRDs

Este diretório contém os PRDs do produto.

Cada PRD deve representar uma demanda, dor, oportunidade, épico ou feature do ponto de vista de negócio e produto.

## Posição no fluxo (OpenSpec)

O PRD é a fonte de verdade de negócio e **alimenta o OpenSpec**, que planeja a entrega:

```text
PRD (docs/prd/)  ->  OpenSpec change (openspec/: proposal/design/tasks)  ->  TDD
```

O planejamento (spec/design/tasks) é uma OpenSpec change em `openspec/`, criada via
`openspec-propose` / `/opsx propose`, que lê o PRD como base (`openspec/config.yaml`).
O design/plano técnico (SDD) fica no `design.md` da change.

## Regra de rastreabilidade

Todo PRD salvo deve ser referenciado em:

- `docs/prd/README.md`
- `CLAUDE.md`
- `AGENTS.md`

Toda spec ou SDD derivada deve referenciar o PRD de origem.

## PRDs

| PRD | Status | Descrição | Arquivo | Specs relacionadas | SDDs relacionadas |
|---|---|---|---|---|---|
