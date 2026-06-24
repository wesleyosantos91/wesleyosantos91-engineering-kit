# CLAUDE.md — Claude Code neste repositório

Entrada operacional para o Claude Code. Enxuto por design — detalhes em `.ai/rules/`
e `docs/ai-harness/`. Manifesto: `.ai/harness.yaml`. Para Codex, ver `AGENTS.md`.

## Contexto (detectado)

Java 25 · Maven (`./mvnw`) · Spring Boot 4.x ou Quarkus · base `__BASE_PACKAGE__` ·
OpenSpec presente · DevContainer Linux.

## Workflow obrigatório

```text
inspect -> plan -> failing test -> minimal implementation -> refactor -> quality gates -> report
```

TDD é obrigatório: **nenhuma produção antes de um teste falhando** (`.ai/rules/tdd.md`).

## Comandos `.claude/commands`

`/plan` · `/implement-tdd` · `/review` · `/debug` · `/quality` · `/openspec-check` ·
`/context-pack`. (OpenSpec: ver também `.claude/commands/opsx/`.)

## Comandos de qualidade

```bash
bash scripts/quality/verify-all.sh --fast   # format-check, checkstyle, unit, package-rules
bash scripts/quality/verify-all.sh --full    # + integration, bdd, jacoco, pit, archunit, package
bash scripts/quality/jacoco.sh               # cobertura >= 90%
bash scripts/quality/mutation-test.sh        # PIT >= 90%
bash scripts/quality/archunit.sh             # arquitetura (fallback package-rules.sh)
bash scripts/ai/openspec-validate.sh         # specs vs código
```

Gate ausente (plugin não configurado) é **reportado como ausente**, não como falha.
Habilitar: `config/pom-quality-plugins.example.xml` (opt-in, diff claro).

## Padrão de pacotes e arquitetura

`web` / `message` / `application` / `domain` / `infrastructure` / `core`.
`domain` **sem** Spring/JPA/AWS/Kafka/HTTP/web/infra; `domain/repository` = interfaces;
DTO de API fora do domínio; controllers/listeners finos. Ver `.ai/rules/architecture.md`
e `.ai/rules/package-organization.md`.

SOLID é obrigatório para código produtivo e reviews: SRP, OCP, LSP, ISP e DIP. Bloqueie
services com múltiplas responsabilidades, interfaces sem consumidor real, herança
desnecessária, regra de negócio em adapters, vazamento de DTO/entity para domínio e
abstração prematura. Ver `.ai/rules/solid.md`.

## OpenSpec / SDD

`PRD -> OpenSpec -> SDD/plano -> TDD -> testes -> validação -> report`. Antes de
implementar: `opsx-context-check.sh` + `openspec-validate.sh`. Requisito não claro →
**bloqueie** e peça spec. Não invente requisitos. Ver `.ai/rules/openspec-sdd.md`.

## Headroom e logs grandes

- Contexto **cirúrgico** por tarefa; não traga o repo inteiro.
- Preserve headroom; use `/compact` quando necessário.
- Resuma logs grandes, mas **preserve o stack trace relevante** inteiro.
- `bash scripts/ai/context-pack.sh` empacota contexto (Repomix/`--compress`).
- Ver `.ai/rules/token-economy.md`.

## Nunca

- Rodar destrutivo sem confirmação: `rm -rf`, `git reset --hard`, `git clean -fdx`,
  `docker system prune -a`, `drop database`, `terraform apply`, `kubectl delete`, `aws *delete*`.
- Exibir/commitar secrets, `.env`, credenciais AWS, certificados, chaves privadas.
- Alterar `pom.xml` com risco (propor + `.example`); deletar arquivos; reestruturar
  pacotes sem aprovação; instalar dependência global automaticamente.
- Ver `.ai/rules/security.md`.

## Checklist antes de finalizar

- [ ] Teste falhando antes da produção (TDD) · unit verde · integration/BDD se aplicável
- [ ] `verify-all.sh --fast`/`--full` verde · JaCoCo/PIT >= 90% (se configurados)
- [ ] ArchUnit/package-rules sem violações · OpenSpec sem divergência
- [ ] SOLID/riscos de design revisados quando houver código produtivo
- [ ] Sem secrets/destrutivo · `.ai/reports/task-report.md` atualizado

## Multi-agent reference

This repository uses a focused agent layer inspired by `wesleyosantos91/multi-agents`, but the local harness is the source of truth.

Use only the agents and skills defined in this repository (`.claude/agents/`, `.claude/skills/`).

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

---

<!-- rtk-instructions v2 -->
# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:
```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)
```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (60-99% savings)
```bash
rtk cargo test          # Cargo test failures only (90%)
rtk go test             # Go test failures only (90%)
rtk jest                # Jest failures only (99.5%)
rtk vitest              # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk pytest              # Python test failures only (90%)
rtk rake test           # Ruby test failures only (90%)
rtk rspec               # RSpec test failures only (60%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)
```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)
```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)
```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%). Format flags (-c, -l, -L, -o, -Z) run raw.
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)
```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)
```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)
```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category | Commands | Typical Savings |
|----------|----------|-----------------|
| Tests | vitest, playwright, cargo test | 90-99% |
| Build | next, tsc, lint, prettier | 70-87% |
| Git | status, log, diff, add, commit | 59-80% |
| GitHub | gh pr, gh run, gh issue | 26-87% |
| Package Managers | pnpm, npm, npx | 70-90% |
| Files | ls, read, grep, find | 60-75% |
| Infrastructure | docker, kubectl | 85% |
| Network | curl, wget | 65-70% |

Overall average: **60-90% token reduction** on common development operations.
<!-- /rtk-instructions -->
