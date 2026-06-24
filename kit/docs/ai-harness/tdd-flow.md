# TDD flow (obrigatório)

Regra completa: `.ai/rules/tdd.md`. Comando: `/implement-tdd` (Claude) ou prompt
`implement-tdd` (Codex).

## Feature

```text
1. entender requisito (spec/OpenSpec/PRD)
2. escrever TESTE FALHANDO (red)
3. bash scripts/quality/test-unit.sh        # confirmar que falha
4. implementação MÍNIMA (green)
5. bash scripts/quality/test-unit.sh        # confirmar verde
6. refatorar (mantendo verde)
7. bash scripts/quality/verify-all.sh --fast
8. bash scripts/ai/task-report.sh
```

## Bugfix

```text
1. reproduzir o bug com teste FALHANDO
2. corrigir
3. provar com teste passando
4. adicionar regressão
```

## Onde colocar o teste

- Regra de domínio → `src/test/java/<base>/domain/...Test.java`
- Caso de uso → `src/test/java/<base>/application/...Test.java`
- Controller web → `@WebMvcTest` em `src/test/java/<base>/web/...Test.java`

## Disciplina

- Nunca escrever produção sem um teste falhando antes.
- Não escrever mais do que o teste exige.
- Cada ciclo termina com build verde e commit pequeno.
