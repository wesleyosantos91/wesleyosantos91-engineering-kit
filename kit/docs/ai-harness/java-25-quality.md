# Java 25 — qualidade

Como o harness trata qualidade em Java 25. Regras detalhadas em `.ai/rules/`.

## Spotless (formatação)

Formatter principal. `format.sh` aplica, `format-check.sh` valida. Config:
`config/spotless/spotless-java25.md`. Regra: `.ai/rules/spotless-formatting.md`.

> **Java 25:** usa **Eclipse JDT** (perfil `config/spotless/eclipse-java-formatter.xml`),
> porque `google-java-format`/Palantir quebram no JDK 25 (`NoSuchMethodError` em
> internals do javac). Imports via engine JavaParser (`cleanthat`).

## Checkstyle (estilo)

`config/checkstyle/checkstyle-java25.xml` + `suppressions.xml`. Foco em imports,
complexidade controlada, nomenclatura e legibilidade — **sem** Javadoc obrigatório.
Regra: `.ai/rules/java-25-checkstyle.md`.

## JaCoCo (cobertura >= 90%)

Line e branch >= 90%. Exclusões só justificadas (bootstrap, gerado, DTO puro, config).
Não excluir domínio/application. Regra: `.ai/rules/jacoco-coverage.md`.

## PIT (mutation score >= 90%)

Valida se os testes asseguram comportamento. Sobreviventes em `domain` = críticos.
Regra: `.ai/rules/pit-mutation-testing.md`. Config: `config/pitest/pitest-rules.md`.

## ArchUnit (arquitetura)

Regras de camada/dependência como teste JUnit 5; fallback `package-rules.sh`.
Regra: `.ai/rules/archunit.md`. Config: `config/archunit/architecture-rules.md`.

## SOLID

SOLID é critério de design obrigatório para código produtivo e reviews. Ele complementa
os gates automatizados: ArchUnit/package-rules cobrem dependências estruturais, enquanto
`.ai/rules/solid.md` cobre riscos como excesso de responsabilidade, abstração prematura,
interfaces sem consumidor real, herança desnecessária e vazamento de DTO/entity para o
domínio.

## Habilitação no build

Nenhum desses plugins foi adicionado ao `pom.xml` automaticamente (risco de quebra
em Java 25 / Spring Boot 4). Use `config/pom-quality-plugins.example.xml` como
proposta: copie os blocos, **valide as versões** contra o repositório central e rode
`./mvnw -q -DskipTests verify` antes de fixar.

## Versão da JDK no ambiente

O DevContainer provê Java 25 (feature `java`, Temurin). O build usa `./mvnw`.
