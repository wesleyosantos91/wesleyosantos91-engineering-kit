# Regra: PIT (mutation score >= 90%)

Mutation score mínimo: **90%**. Mutation testing valida se os testes realmente
**asseguram comportamento** (não só executam linhas).

## Comando

```bash
bash scripts/quality/mutation-test.sh
```

- Roda PIT quando configurado e calcula o score a partir de `mutations.xml`.
- Reporta mutantes sobreviventes e sinaliza score `< 90%`.
- Quando não configurado, avisa (não falha) e aponta como habilitar.

## Prioridade dos mutantes sobreviventes

- `domain` → **crítico**, corrigir sempre.
- `application services` → **relevante**.
- `DTO`/`config`/gerado → excluível **com justificativa**.

Não mascarar score com exclusões abusivas.

## Habilitação

Bloco PIT em `config/pom-quality-plugins.example.xml` (inclui `pitest-junit5-plugin`
e `mutationThreshold=90`). Detalhes e leitura de relatório em
[`../../config/pitest/pitest-rules.md`](../../config/pitest/pitest-rules.md).
