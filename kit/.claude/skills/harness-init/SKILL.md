---
name: harness-init
description: Onboarding inicial após aplicar o chassis (detect -> validar agentes/skills -> wire quality gates -> git init -> primeiro contexto). Spring Boot e Quarkus.
---

# Skill: harness-init

## Objetivo
Executar, de forma guiada e não-destrutiva, os passos pós-bootstrap do chassis para
deixar o projeto operante: detecção, validação do harness, habilitação dos quality
gates adequados ao estágio do projeto, inicialização do repositório e primeiro
retrato de contexto.

## Quando usar
Logo após `bootstrap.sh` aplicar o chassis num projeto novo ou existente.

## Quando NÃO usar
Projeto já onboarded (rode skills específicas: tdd-implementation, pre-pr-review).

## Inputs esperados
- Diretório alvo já com o harness copiado (`.ai/`, `.claude/`, `scripts/`).
- `pom.xml` (Maven) ou `build.gradle(.kts)` (Gradle) presente.

## Workflow
1. **Detectar**: `bash scripts/ai/detect-project.sh` — captura build tool, Java,
   framework (**Spring Boot ou Quarkus**), pacote-base, testes e gates presentes.
2. **Validar harness**: `validate-claude-agents.sh`, `validate-codex-agents.sh`,
   `validate-skills.sh` — todos devem passar antes de seguir.
3. **Wire quality gates conforme o estágio**:
   - Sempre seguros (qualquer código): **Spotless (Eclipse JDT no Java 25) + Checkstyle**.
   - **JaCoCo 90% / PIT 90%**: só wire quando houver código de domínio testável;
     em esqueleto vazio os thresholds são teatro (passam à toa ou quebram sem ganho).
   - Base: `config/pom-quality-plugins.example.xml` (Maven) — **valide as versões**.
     Quarkus usa o mesmo bloco de plugins (são framework-agnósticos); apenas confirme
     que o `quarkus-maven-plugin` continua na fase `package`.
4. **Aplicar formatação** antes do primeiro check: `bash scripts/quality/format.sh`.
5. **Validar build**: `./mvnw -q -DskipTests verify` (ou `gradle check`).
6. **git init** (se ainda não for repo) + primeiro commit do harness aplicado.
7. **Primeiro contexto**: `bash scripts/ai/context-pack.sh` e `bash scripts/ai/preflight.sh`.

## Config de referência (validada — `poc-devcontainer`, Java 25 / Spring Boot 4)
Versões já pinadas e testadas; use como ponto de partida (via `<properties>`):

| Plugin | Versão | Wiring |
|---|---|---|
| `spotless-maven-plugin` | `2.44.5` | Eclipse JDT (`config/spotless/eclipse-java-formatter.xml`) + `cleanthat-javaparser-unnecessaryimport` + `importOrder`; goal `check` na fase **verify** |
| `maven-checkstyle-plugin` | `3.6.0` (checkstyle `10.26.1`) | `config/checkstyle/checkstyle-java25.xml`; goal `check` na fase **validate** |
| `jacoco-maven-plugin` | `0.8.13` | `coverage.minimum=0.90` (line+branch); exclui `**/*Application.*`, `**/config/**`, `**/dto/**` — **não** exclui domínio/application |
| `pitest-maven` (+`pitest-junit5-plugin` `1.2.3`) | `1.19.6` | `mutation.threshold=90`; **NÃO** amarrado ao lifecycle — roda via `scripts/quality/mutation-test.sh` (`pitest:mutationCoverage`) |
| `archunit-junit5` (test dep) | `1.4.0` | regras de arquitetura como teste JUnit 5 |

Decisões que importam:
- Thresholds em `<properties>` (`coverage.minimum`, `mutation.threshold`) — um lugar só para ajustar.
- PIT fora do `verify` de propósito: evita quebrar build comum; rode-o explicitamente no pre-PR.
- No Java 25, Spotless **só** funciona com Eclipse JDT (google-java-format/Palantir quebram).

## Notas por framework
- **Spring Boot**: gate roda na fase `verify`; `*Application` e `config/**` ficam
  fora da cobertura (bootstrap/gerado).
- **Quarkus**: idem; lembre que testes de integração nativos (`@QuarkusIntegrationTest`)
  rodam em `failsafe` — não inclua no JaCoCo unitário sem ajustar a fase.

## Comandos permitidos
```bash
bash scripts/ai/detect-project.sh
bash scripts/ai/validate-claude-agents.sh
bash scripts/ai/validate-codex-agents.sh
bash scripts/ai/validate-skills.sh
bash scripts/quality/format.sh
bash scripts/quality/format-check.sh
bash scripts/quality/checkstyle.sh
bash scripts/ai/context-pack.sh
bash scripts/ai/preflight.sh
git init
```

## Saída esperada
- Relatório de detecção + validações verdes.
- `pom.xml`/`build.gradle` com os gates adequados ao estágio, build passando.
- Repositório inicializado (opcional) e `.ai/reports/` com o primeiro contexto.

## Critérios de qualidade
- Não wire thresholds de cobertura/mutação em projeto sem domínio testável.
- No Java 25, Spotless **deve** usar Eclipse JDT (não google-java-format/Palantir).
- Nunca sobrescrever pom/config sem validar `verify` depois.

## Segurança
- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply, kubectl delete, aws *delete*).
- Nunca expor secrets/.env/credenciais. Ver .ai/rules/security.md.
