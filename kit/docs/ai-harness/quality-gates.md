# Quality gates

Orquestrador: `scripts/quality/verify-all.sh`.

```bash
bash scripts/quality/verify-all.sh --fast   # format-check, checkstyle, unit, package-rules
bash scripts/quality/verify-all.sh --full    # todos os gates + package
# flags: --no-mutation --no-integration --no-bdd --skip-coverage
```

## Gates

| # | Gate | Script | Regra | Ausência |
|---|------|--------|-------|----------|
| 1 | Format | `format-check.sh` | Spotless | avisa, não falha |
| 2 | Style | `checkstyle.sh` | Checkstyle Java 25 | valida config, avisa |
| 3 | Unit | `test-unit.sh` | JUnit 5 / Surefire | — |
| 4 | Integration | `test-integration.sh` | Failsafe `*IT` | avisa; **falha** se há IT sem runner |
| 5 | BDD | `test-bdd.sh` | Cucumber/JBehave/Spock | avisa |
| 6 | Coverage | `jacoco.sh` | JaCoCo line+branch >= 90% | avisa |
| 7 | Mutation | `mutation-test.sh` | PIT score >= 90% | avisa |
| 8 | Architecture | `archunit.sh` | ArchUnit (fallback `package-rules.sh`) | usa fallback |
| 9 | Package | `package` / `assemble` | build empacota | — |

`quality-summary.sh` consolida tudo em `.ai/reports/quality-summary.md`.

## Filosofia de falha

- **Falha real** = gate configurado que não passou (ex.: teste vermelho, violação de arquitetura, IT sem runner).
- **Ausente** = plugin/ferramenta não configurada → reportado como ausente, **não** como falha injusta.
- Habilitar gates de build: `config/pom-quality-plugins.example.xml` (opt-in, diff claro).

## Integração

- Maven: `./mvnw` (preferido) ou `mvn`. Gradle: `./gradlew` ou `gradle` (detectado automaticamente).
- Tudo roda em Linux/DevContainer; scripts com `set -euo pipefail`, idempotentes, sem destrutivo.
