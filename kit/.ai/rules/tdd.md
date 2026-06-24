# Regra: TDD obrigatório

**Nenhuma implementação de feature começa pelo código produtivo.** O teste vem
primeiro, sempre.

## Fluxo de feature

```text
1. entender o requisito (spec/PRD/OpenSpec quando houver)
2. localizar ou criar o teste
3. escrever TESTE FALHANDO (red)
4. implementar o MÍNIMO para passar (green)
5. refatorar (mantendo verde)
6. rodar unit tests
7. rodar quality gates
8. atualizar o relatório de tarefa
```

## Fluxo de bugfix

```text
1. reproduzir o bug com um teste FALHANDO
2. corrigir
3. provar a correção com o teste passando
4. adicionar teste de regressão se necessário
```

## Disciplina

- Um ciclo red→green→refactor por unidade de comportamento.
- Não escreva mais produção do que o teste exige.
- Commits pequenos; cada passo termina com o build verde.
- O teste é o critério de aceite executável da spec.

Comandos: `bash scripts/quality/test-unit.sh` e `bash scripts/quality/verify-all.sh --fast`.
Ver também [`testing.md`](./testing.md), [`bdd.md`](./bdd.md).
