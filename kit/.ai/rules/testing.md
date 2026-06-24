# Regra: Testes

## Testes unitários (obrigatórios)

- `domain` e `application` **devem** ter testes unitários.
- `controller` (web) tem teste web quando aplicável (ex.: `@WebMvcTest`).
- `mapper` tem teste quando houver lógica.
- Validações e regras de negócio têm teste explícito.
- Todo bugfix exige teste de **regressão**.
- Nome: `*Test.java` (Surefire). Framework: JUnit 5.

Comando: `bash scripts/quality/test-unit.sh`

## Testes de integração (quando há dependência externa)

Obrigatórios quando existir: banco/JPA, DynamoDB, Kafka, SQS, SNS, S3, HTTP client,
cache, filesystem, Docker, LocalStack, Testcontainers.

- Maven: Failsafe, classes `*IT` / `*IntegrationTest`.
- Gradle: source set / task `integrationTest`.
- Preferir **Testcontainers/LocalStack** a mocks para infra real.

Comando: `bash scripts/quality/test-integration.sh`
(Falha se houver arquivos `*IT`/`*IntegrationTest` sem runner configurado.)

## Pirâmide

```
muitos   unit  (rápidos, isolam regra de negócio)
alguns   integration (dependências reais via containers)
poucos   bdd/e2e (aceite de comportamento)
```

Gates de cobertura: [`jacoco-coverage.md`](./jacoco-coverage.md) e
[`pit-mutation-testing.md`](./pit-mutation-testing.md).
