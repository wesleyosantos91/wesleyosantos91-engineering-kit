# AGENTS.md — instruções para agentes (Codex CLI e outros)

Instrução operacional principal para agentes neste repositório Java. Direto e técnico.
Detalhes em `.ai/rules/` e `docs/ai-harness/`. Manifesto: `.ai/harness.yaml`.

## Repositório (detectado)

- **Java 25**, **Maven** (`./mvnw`), **Spring Boot 4.x ou Quarkus**.
- Base package: `__BASE_PACKAGE__`.
- OpenSpec presente (`openspec/`, `schema: spec-driven`).
- DevContainer Linux-friendly (`.devcontainer/`).

## Comandos essenciais

```bash
# Inspeção (read-only)
bash scripts/ai/preflight.sh
bash scripts/ai/detect-project.sh

# Qualidade
bash scripts/quality/verify-all.sh --fast    # format-check, checkstyle, unit, package-rules
bash scripts/quality/verify-all.sh --full     # todos os gates
bash scripts/quality/test-unit.sh
bash scripts/quality/jacoco.sh                 # cobertura >= 90%
bash scripts/quality/mutation-test.sh          # PIT >= 90%
bash scripts/quality/archunit.sh               # arquitetura (fallback package-rules.sh)

# Specs e relatórios
bash scripts/ai/openspec-validate.sh
bash scripts/ai/task-report.sh
```

## Workflow obrigatório

```text
inspect -> plan -> failing test -> minimal implementation -> refactor -> quality gates -> report
```

## TDD (obrigatório)

Nenhuma implementação começa pelo código produtivo.
`entender requisito -> teste falhando -> implementação mínima -> refatorar -> unit tests -> quality gates -> report`.
Bugfix: `reproduzir com teste falhando -> corrigir -> provar passando -> regressão`.
Ver `.ai/rules/tdd.md`.

## BDD (quando aplicável)

Use quando houver comportamento de negócio, fluxo de usuário, regra regulatória ou
aceite funcional. Estrutura: `src/test/resources/features/` + `src/test/java/<base>/bdd/`.
Não adicionar Cucumber/JBehave/Spock sem confirmar dependência no build. Ver `.ai/rules/bdd.md`.

## Testes

- **Unitários obrigatórios** em `domain` e `application`; controllers (web) quando aplicável; mappers com lógica; bugfix com regressão.
- **Integração** quando houver banco/JPA, DynamoDB, Kafka, SQS, SNS, S3, HTTP client, cache, filesystem, Docker, LocalStack, Testcontainers. Maven Failsafe (`*IT`/`*IntegrationTest`).
- Ver `.ai/rules/testing.md`.

## Padrão de pacotes

```text
web/ (api: v1, controller, request, response, mapper, exception; grpc; graphql)
message/ (kafka, sqs, sns)
application/ (service, command, query, dto)
domain/ (model, service, repository, event, exception)
infrastructure/ (persistence, client, storage, messaging, config, security, resilience, logging, metrics, openapi)
core/ (annotation, validation, mapper, util)
```

Regras: `domain` sem Spring/JPA/AWS/Kafka/HTTP/web/infrastructure; `domain/repository` =
interfaces (impl em `infrastructure`); DTO de API fora do domínio; Entity JPA ≠ Aggregate;
controllers/listeners finos; `core` não é lixeira. Ver `.ai/rules/architecture.md` e
`.ai/rules/package-organization.md`.

## SOLID e riscos de design

SOLID é obrigatório para código produtivo e reviews: SRP, OCP, LSP, ISP e DIP devem
guiar classes, interfaces, pacotes e dependências. Bloqueie riscos como service com
múltiplas responsabilidades, interface sem consumidor real, herança desnecessária,
regra de negócio em controller/listener/repository implementation, DTO/entity vazando
para domínio e abstração prematura. Ver `.ai/rules/solid.md`.

## Quality gates

- **Spotless** (formatação) — `.ai/rules/spotless-formatting.md`.
- **Checkstyle Java 25** — `config/checkstyle/checkstyle-java25.xml`, `.ai/rules/java-25-checkstyle.md`.
- **JaCoCo >= 90%** (line+branch) — `.ai/rules/jacoco-coverage.md`.
- **PIT mutation score >= 90%** — `.ai/rules/pit-mutation-testing.md`.
- **ArchUnit** (fallback `package-rules.sh`) — `.ai/rules/archunit.md`.
- Plugins ausentes são **reportados como ausentes**, não como falha. Habilitar via
  `config/pom-quality-plugins.example.xml` (opt-in, com diff claro).

## OpenSpec / SDD

Fluxo: `PRD -> OpenSpec change/spec -> SDD/plano -> TDD -> testes -> validação -> report`.
Antes de implementar: `opsx-context-check.sh` + `openspec-validate.sh`. Requisito não
claro → **bloqueie** e peça spec. Não invente requisitos. Ver `.ai/rules/openspec-sdd.md`.

## Segurança

NUNCA sem confirmação explícita: `rm -rf`, `git reset --hard`, `git clean -fdx`,
`docker system prune -a`, `drop database`, `terraform apply`, `kubectl delete`, `aws *delete*`.
NUNCA exibir/logar/commitar: tokens, secrets, `.env`, credenciais AWS, certificados,
chaves privadas. Ver `.ai/rules/security.md`.

## Economia de contexto

Contexto cirúrgico por tarefa; Repomix (`scripts/ai/context-pack.sh`) e RTK quando úteis;
preserve headroom; resuma logs grandes mantendo stack trace; não comprimir código.
Não instalar dependência global automaticamente. Ver `.ai/rules/token-economy.md`.

## Restrições

- Não implementar regra de negócio sem spec.
- Não reestruturar pacotes existentes sem aprovação.
- Não deletar arquivos existentes.
- Não alterar `pom.xml` com risco — propor + `.example`.
- Scripts: `set -euo pipefail`, idempotentes, Linux/DevContainer, sem destrutivo.

## Checklist antes de finalizar a tarefa

- [ ] Teste falhando criado antes da produção (TDD)
- [ ] Unit tests passando; integration/BDD quando aplicável
- [ ] `verify-all.sh --fast` (ou `--full`) verde
- [ ] JaCoCo >= 90% e PIT >= 90% (quando configurados)
- [ ] ArchUnit/package-rules sem violações
- [ ] SOLID/riscos de design revisados quando houver código produtivo
- [ ] OpenSpec validado; sem divergência spec×código
- [ ] Sem secrets, sem comando destrutivo
- [ ] `.ai/reports/task-report.md` atualizado

## Multi-agent reference

This repository uses a focused agent layer inspired by `wesleyosantos91/multi-agents`, but the local harness is the source of truth.

Use only the agents and skills defined in this repository (`.codex/agents/`, `.agents/skills/`).

Reference adaptation docs:
- `docs/ai-harness/reference-multi-agents.md`
- `docs/ai-harness/agents.md`
- `docs/ai-harness/skills.md`
- `.ai/references/agent-selection-matrix.md`

## Fluxo PRD → Spec/SDD

Este repositório usa PRDs como fonte de verdade de negócio e **OpenSpec** como mecanismo
spec-driven. Cadeia canônica (ver também `## OpenSpec / SDD`):

```text
PRD (docs/prd/)  ->  OpenSpec change (openspec/: proposal/design/tasks)  ->  TDD
```

- **PRDs** em `docs/prd/` (fonte de verdade de produto/negócio; skill `prd-produto`).
- O **planejamento da entrega** (spec/design/tasks) é uma **OpenSpec change** em `openspec/`,
  criada via `openspec-propose` / `/opsx propose`, que lê o PRD como base (`openspec/config.yaml`).
- O **design/plano técnico (SDD)** fica no `design.md` da change.

### Regra obrigatória

Antes de iniciar qualquer nova spec ou SDD, leia primeiro o PRD correspondente da demanda.

Nenhuma spec ou SDD deve ser criada sem referência explícita ao PRD de origem.

A spec ou SDD deve conter frontmatter com:

```md
---
source_prd: docs/prd/<nome-da-iniciativa>.md
source_prd_id: PRD-<nome-em-kebab-case>
---
```

### PRDs registrados

Manter esta lista atualizada sempre que um novo PRD for criado:

<!-- PRD-INDEX:START -->
<!-- PRD-INDEX:END -->

### Skill relacionada

Use a skill `prd-produto` para:

* criar PRDs
* revisar PRDs
* recortar MVP
* gerar perguntas de discovery
* validar prontidão para SDD/spec
* referenciar PRDs em `CLAUDE.md`, `AGENTS.md` e `docs/prd/README.md`
