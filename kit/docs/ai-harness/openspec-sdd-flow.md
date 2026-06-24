# OpenSpec / SDD / PRD flow

Regra: `.ai/rules/openspec-sdd.md`. Validação: `scripts/ai/openspec-validate.sh`.

## Fluxo

```text
PRD/product  ->  OpenSpec change/spec  ->  SDD/plano técnico  ->  implementação TDD
             ->  testes  ->  validação (openspec-check)  ->  relatório
```

## Estado neste repo

- **OpenSpec presente**: `openspec/` (`schema: spec-driven`), com `changes/` e `specs/`.
- Comandos OpenSpec do Claude em `.claude/commands/opsx/` (explore/propose/apply/archive/sync).
- **PRD**: fonte de verdade de produto/negócio em `docs/prd/` (gerados pela skill
  `prd-produto` / `/prd-produto`; template em `docs/product/PRD.template.md`). O PRD
  **alimenta** a OpenSpec change — não inventar requisitos. O design/plano técnico (SDD)
  fica no `design.md` da change.

## Como o OpenSpec lê o PRD

A ligação é feita em `openspec/config.yaml` (`context` + `rules`), que o CLI injeta na IA
ao rodar `openspec instructions <artefato> --change <nome>` (passo da skill `openspec-propose`
/ `/opsx propose`). O `context` instrui a **ler o PRD em `docs/prd/` antes de gerar
proposal/design/spec/tasks** e a não inventar requisitos; as `rules` por artefato exigem
referência ao PRD de origem. Assim o fluxo PRD → OpenSpec é aplicado pelo próprio OpenSpec,
não só pela convenção em `CLAUDE.md`/`AGENTS.md`.

## Antes de implementar

```bash
bash scripts/ai/opsx-context-check.sh <arquivo-da-tarefa.md>   # exige contexto mínimo
bash scripts/ai/openspec-validate.sh                            # specs vs código
```

Checklist de contexto mínimo: objetivo, requisito, spec, plano técnico, arquivos,
teste esperado, tipo de teste, critério de pronto, risco, rollback.

## Validação spec × código

`openspec-validate.sh` lista specs/changes e confronta (heurístico) endpoints/eventos
declarados vs anotações no código, gerando `.ai/reports/openspec-check.md`.
Divergências devem ser resolvidas; requisito não claro **bloqueia** a implementação.

## Regras

- Não inventar requisitos. Sem spec/PRD → documentar ausência e usar template.
- Toda implementação referencia uma spec/change.
- A spec é a fonte da verdade; código diverge → corrigir código (após revisar spec).
