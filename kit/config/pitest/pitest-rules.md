# PIT — Mutation Testing (score mínimo 90%)

PIT insere mutações no bytecode e verifica se os testes as **matam**. Cobertura
alta (JaCoCo) sem mutation testing pode esconder testes que não asseguram
comportamento. Por isso o harness exige **mutation score >= 90%**.

## Regra

```text
mutation score mínimo: 90%
```

- Mutantes sobreviventes em **domain** são **críticos** — corrija.
- Mutantes em **application services** são **relevantes**.
- Mutantes em **DTO/config/código gerado** podem ser excluídos **com justificativa**.
- **Não** mascare o score com exclusões abusivas.

## Como habilitar (Maven)

Copie o bloco do PIT de [`config/pom-quality-plugins.example.xml`](../pom-quality-plugins.example.xml).
Inclui `pitest-junit5-plugin` (JUnit 5) e `mutationThreshold=90`.

```bash
bash scripts/quality/mutation-test.sh   # roda PIT e lê o score do mutations.xml
```

## Como habilitar (Gradle)

```kotlin
plugins { id("info.solidsoft.pitest") version "<valide>" }
pitest {
  junit5PluginVersion.set("<valide>")
  mutationThreshold.set(90)
  targetClasses.set(listOf("<base-package>.domain.*", "<base-package>.application.*"))
}
```

Task: `pitest`.

## Lendo o relatório

- HTML: `target/pit-reports/<timestamp>/index.html`
- XML (usado pelo script): `target/pit-reports/**/mutations.xml`

Para cada mutante `SURVIVED`, escreva um teste que falhe com a mutação aplicada.
