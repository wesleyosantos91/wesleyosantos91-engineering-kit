# Spotless — formatação Java 25

Spotless é o **mecanismo principal de formatação** do harness. Ele formata e valida
o código de forma determinística, evitando discussões de estilo em review.

## O que o Spotless cobre aqui

- Formatação de **Java** (Google Java Format ou Palantir).
- Remoção de **imports não usados** e ordenação de imports.
- Remoção de **espaços finais** e garantia de **newline final**.
- Formatação de **Markdown** e **YAML** (quando habilitado).

## Comandos (via harness)

```bash
bash scripts/quality/format.sh        # aplica formatação (spotless:apply / spotlessApply)
bash scripts/quality/format-check.sh  # valida formatação (spotless:check / spotlessCheck)
```

Se o Spotless ainda não estiver no build, os scripts **avisam e não falham**.

## ⚠️ Java 25: use Eclipse JDT, não google-java-format

`google-java-format` (e Palantir) dependem de internals do `com.sun.tools.javac`
que **mudaram no JDK 25** → falham com `NoSuchMethodError`. Por isso este projeto usa
o **Eclipse JDT formatter** (não usa internals do javac), com perfil em
[`eclipse-java-formatter.xml`](./eclipse-java-formatter.xml) (indentação por espaços,
para alinhar com o Checkstyle). A remoção de imports usa o engine JavaParser
(`cleanthat-javaparser-unnecessaryimport`), também independente do javac.

Reavalie o google-java-format quando uma versão com suporte a JDK 25 estiver disponível.

## Configuração (Maven) — já aplicada no pom.xml

```text
spotless:apply   # formata
spotless:check   # valida (amarrado ao phase verify)
```

## Como habilitar (Gradle)

```kotlin
plugins { id("com.diffplug.spotless") version "<valide>" }
spotless {
  java { googleJavaFormat(); removeUnusedImports(); trimTrailingWhitespace(); endWithNewline() }
}
```

Tasks: `spotlessApply`, `spotlessCheck`.

> Decisão de estilo: escolha **um** formatter (googleJavaFormat **ou** palantirJavaFormat)
> e mantenha. Misturar gera ruído de diff.
