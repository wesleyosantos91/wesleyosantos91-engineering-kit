# Regra: ArchUnit

ArchUnit valida a arquitetura como teste JUnit 5. Enquanto não configurado, o
fallback `scripts/quality/package-rules.sh` (grep/find) cobre o essencial.

## Comando

```bash
bash scripts/quality/archunit.sh   # roda ArchUnit, ou cai no fallback
```

## Regras validadas

```text
domain !-> Spring / JPA / AWS SDK / Kafka / SQS / SNS / web / infrastructure
web !-> infrastructure.persistence.jpa (direto)
message !-> infrastructure.persistence.jpa (direto)
application !-> detalhes técnicos diretos
repositories técnicos em infrastructure
controllers em web; listeners em message
DTOs de API fora do domínio
```

## Habilitação

Dependência `com.tngtech.archunit:archunit-junit5` (test scope) + teste em
`src/test/java/<base-package>/architecture/`. Esqueleto e regra em camadas em
[`../../config/archunit/architecture-rules.md`](../../config/archunit/architecture-rules.md).

> Não adicione a dependência automaticamente; proponha no build com diff claro.
