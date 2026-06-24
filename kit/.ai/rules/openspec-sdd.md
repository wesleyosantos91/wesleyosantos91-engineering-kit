# Regra: OpenSpec / SDD / PRD

A **especificação é a fonte da verdade**. Código deriva da spec; quando divergem,
a spec ganha (e você atualiza o código após revisar a spec).

## Fluxo

```text
PRD/product -> OpenSpec change/spec -> SDD/plano técnico -> implementação TDD
            -> testes -> validação -> relatório
```

## Antes de implementar

- Rode `bash scripts/ai/opsx-context-check.sh <tarefa.md>` — exige objetivo,
  requisito, spec, plano, arquivos, teste esperado, tipo de teste, critério de
  pronto, risco, rollback.
- Rode `bash scripts/ai/openspec-validate.sh` — lista specs/changes e confronta
  endpoints/eventos/regras vs código (relatório em `.ai/reports/openspec-check.md`).
- Se o requisito **não estiver claro**, **bloqueie** a implementação e peça spec.

## Detecção

Diretórios reconhecidos: `openspec/`, `.openspec/`, `specs/`, `docs/specs/`.
Neste repo: **OpenSpec presente** (`openspec/`, `schema: spec-driven`).

## Restrições

- **Não inventar requisitos.** Se faltar spec/PRD, documentar a ausência e usar
  o template (`docs/product/PRD.template.md`, `docs/ai-harness/openspec-sdd-flow.md`).
- Toda implementação deve referenciar a spec/change correspondente.
