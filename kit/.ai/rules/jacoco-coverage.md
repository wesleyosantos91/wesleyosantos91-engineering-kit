# Regra: JaCoCo (cobertura >= 90%)

Cobertura mínima exigida: **90%** — preferencialmente `line >= 90%` **e**
`branch >= 90%`.

## Comando

```bash
bash scripts/quality/jacoco.sh
```

- Se JaCoCo estiver no build, roda `verify` + `jacoco:check` e lê o CSV.
- Se o threshold do build for **< 90%**, o script **reporta divergência**.
- Se JaCoCo não estiver configurado, avisa (não falha) e aponta como habilitar.

## Habilitação

Bloco JaCoCo em `config/pom-quality-plugins.example.xml` (limites `LINE` e `BRANCH`
em `0.90`). Gradle: `jacocoTestReport` + `jacocoTestCoverageVerification`.

## Exclusões aceitáveis (somente com justificativa)

```text
Application bootstrap
código gerado
DTO puro sem lógica
configuration simples
migrations
clients gerados
```

**Não** excluir `domain` nem `application services` sem justificativa explícita.
Cobertura alta sem mutation testing engana — ver [`pit-mutation-testing.md`](./pit-mutation-testing.md).
