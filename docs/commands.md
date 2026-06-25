# 🧭 Comandos & atalhos

[![⬅ README](https://img.shields.io/badge/⬅-README-1f6feb?style=flat-square)](../README.md)
[![CC BY-SA 4.0](https://img.shields.io/badge/license-CC%20BY--SA%204.0-1f6feb?style=flat-square)](../LICENSE)

**📖 Docs:** **Comandos** · [Getting Started](getting-started.md) · [Atualizar](updating.md) · [Arquitetura](architecture.md) · [Windows](windows.md)

Cheatsheet de tudo que o kit traz, para acelerar a adoção — funciona para **Claude Code**
e **Codex** (cada um com seu mecanismo).

## 📑 Índice

- [Ciclo de vida do kit](#-ciclo-de-vida-do-kit)
- [Claude Code](#-claude-code) · [Codex](#-codex--prompts-e-skills) · [Skills](#-skills)
- [Em detalhe: prd-produto e opsx](#-em-detalhe-os-fluxos-principais)
- [RTK](#-rtk) · [Caveman](#-caveman)
- [Qualidade](#-qualidade) · [Teste de carga](#-teste-de-carga)
- [OpenSpec e relatórios](#-openspec-e-relatórios) · [MCPs](#-mcps)

---

## 🔁 Ciclo de vida do kit

```bash
git submodule add https://github.com/wesleyosantos91/wesleyosantos91-engineering-kit .engineering-kit
bash .engineering-kit/bootstrap.sh      # popula a raiz (+ tools, se dentro do container)
bash .engineering-kit/update.sh         # puxa o kit novo (git submodule update --remote) + re-checa symlinks
bash .engineering-kit/uninstall.sh      # remove symlinks/scaffold (--purge-copies remove também os copiados)
```

---

## 🟠 Claude Code

Slash commands em `.claude/commands/`:

| Comando | O que faz |
|---|---|
| `/plan` | Planeja a implementação antes de codar. |
| `/implement-tdd` | Implementa via TDD (teste falhando → mínimo → refatora). |
| `/review` | Revisa o diff atual. |
| `/debug` | Investiga/depura um problema. |
| `/quality` | Roda e interpreta os quality gates. |
| `/pre-pr` | Checklist técnico final antes do PR (GO/NO-GO). |
| `/arch-review` | Revisa arquitetura/pacotes/SOLID. |
| `/contract-review` | Detecta breaking changes de contrato/API. |
| `/qa-review` | Revisão de QA. |
| `/security-check` | Checagem de segurança das mudanças. |
| `/adr` | Gera um ADR (Architecture Decision Record). |
| `/docs` | Gera/atualiza documentação. |
| `/context-pack` | Empacota contexto econômico do repo (Repomix). |
| `/prd-produto` | Gera/revisa **PRD de produto** (base p/ OpenSpec). |
| `/openspec-check` | Valida specs × código. |
| `/opsx propose` · `/opsx apply` · `/opsx archive` · `/opsx explore` · `/opsx sync` | Fluxo OpenSpec. |
| `/agents` · `/spawn-review-team` | Orquestra agentes / time de review. |
| `/local-setup` | Ajustes de setup local. |

> No Claude Code, digite `/` para ver a lista. As **skills** ativam sozinhas pelo contexto.

---

## 🟣 Codex — prompts e skills

O Codex **não tem slash-commands**; o equivalente são **prompts** e **skills auto-descobertas**.

**Prompts** (`.ai/prompts/codex/`): aponte/cole o prompt e informe a tarefa.

| Intenção | Prompt |
|---|---|
| Planejar | `.ai/prompts/codex/plan.md` |
| Implementar (TDD) | `.ai/prompts/codex/implement-tdd.md` |
| Revisar diff | `.ai/prompts/codex/review.md` |
| Debugar | `.ai/prompts/codex/debug.md` |
| Qualidade | `.ai/prompts/codex/quality.md` |
| OpenSpec | `.ai/prompts/codex/openspec-check.md` |

**Skills**: o Codex descobre automaticamente as skills em `.agents/skills/` (segue symlink).
Invoque com `/skills` ou mencionando `$nome` (ex.: `$prd-produto`).

---

## 🧠 Skills

Claude em `.claude/skills/` · Codex em `.agents/skills/`:

| Skill | Para quê |
|---|---|
| `prd-produto` | Transformar ideia/dor/épico em **PRD** (discovery, escopo, critérios, riscos). |
| `tdd-implementation` | Implementar feature/bugfix via TDD obrigatório. |
| `java-quality-gate` | Rodar/interpretar gates Java 25 (Spotless, Checkstyle, JaCoCo, PIT, ArchUnit). |
| `mutation-testing-review` | Analisar mutantes sobreviventes (PIT, meta 90%). |
| `package-architecture-review` | SOLID, organização de pacotes, isolamento do domínio. |
| `api-contract-review` | Breaking changes e versionamento de contrato. |
| `pre-pr-review` | Checklist técnico antes do PR. |
| `adr-generation` | Gerar ADR a partir do template. |
| `context-pack` | Empacotar contexto do repo p/ os agentes. |
| `openspec-validation` | Validar implementação × OpenSpec/SDD/PRD. |
| `harness-init` | Onboarding pós-bootstrap (só Claude). |
| `openspec-*` | Skills de ferramenta do OpenSpec (`explore/propose/apply/archive/sync`). |

Validar as skills: `bash scripts/ai/validate-skills.sh`

---

## 🔎 Em detalhe: os fluxos principais

### 📝 `/prd-produto` — Product Requirements Document

Transforma uma **ideia / dor / oportunidade / épico / feature** num **PRD** focado em
**negócio e produto** (não em arquitetura/código). O PRD vira a **fonte de verdade** que
alimenta as specs/SDD via OpenSpec.

**Modos** (passe o modo antes da descrição; default `auto`):

| Modo | O que entrega |
|---|---|
| `auto` | Escolhe o formato pelo tamanho/clareza da demanda. |
| `discovery` | **Discovery Brief**: problema, hipóteses, perguntas de descoberta. |
| `lean` | **PRD Lean**: escopo enxuto, critérios essenciais (bom p/ POC/MVP). |
| `completo` | **PRD Completo**: contexto, requisitos (RN/RF/RB), critérios de aceite, métricas, riscos, *Definition of Ready*. |
| `mvp` | Recorte de **MVP** a partir de um PRD/ideia maior. |
| `review` | Revisa um PRD existente (lacunas, ambiguidades, prontidão). |
| `perguntas` | Só as **perguntas de refinamento** que faltam responder. |
| `salvar` | Salva em `docs/prd/<iniciativa>.md` e referencia nos índices. |
| `referenciar` | Liga o PRD em `CLAUDE.md` / `AGENTS.md` / `docs/prd/README.md`. |
| `pre-sdd` | Valida se o PRD está pronto p/ virar uma OpenSpec change. |

**Exemplos**
```text
/prd-produto  Quero um encurtador de links com expiração e métricas de cliques
/prd-produto lean  Importar CSV de clientes e validar e-mails
/prd-produto review docs/prd/encurtador-links.md
/prd-produto mvp  docs/prd/encurtador-links.md
```

**Saída:** artefato do modo + **caminho sugerido** `docs/prd/<iniciativa>.md`, com premissas,
perguntas abertas, riscos e métricas. No Codex, use a skill `$prd-produto`.

> **Regra:** nenhuma spec/SDD é criada sem ler antes o PRD de origem. O PRD é referenciado
> em `docs/prd/README.md`, `CLAUDE.md` e `AGENTS.md`.

### 📐 `/opsx …` — OpenSpec (spec-driven)

Fluxo OpenSpec, do PRD à entrega. Cadeia canônica:

```text
PRD (docs/prd/) ──/opsx propose──> OpenSpec change ──/opsx apply──> TDD ──/opsx archive
                                   (proposal+design+tasks)                 (+ /opsx sync)
```

| Comando | Fase | O que faz |
|---|---|---|
| `/opsx explore` | Pensar | Modo "parceiro de raciocínio": investiga, esclarece requisitos. **Não implementa** — pode criar artefatos OpenSpec. |
| `/opsx propose` | Planejar | Cria a **change** e gera os artefatos: `proposal.md` (o quê & porquê), `design.md` (como), `tasks`. Lê o **PRD** como base (`openspec/config.yaml`). |
| `/opsx apply` | Implementar | Implementa as **tasks** da change (via TDD). Ex.: `/opsx apply add-auth`. |
| `/opsx archive` | Finalizar | Arquiva a change concluída. Ex.: `/opsx archive add-auth`. |
| `/opsx sync` | Specs | Faz merge inteligente das **delta specs** da change nas specs principais. |

**Exemplo de ponta a ponta**
```text
/prd-produto completo  Autenticação por e-mail + senha com bloqueio após 5 tentativas
/opsx propose                  # cria a change lendo o PRD
/opsx apply <nome-da-change>    # implementa as tasks (TDD)
bash scripts/ai/openspec-validate.sh
/opsx archive <nome-da-change>  # arquiva
```

> O **SDD/plano técnico** vive no `design.md` da change. As mudanças de spec ficam em
> `openspec/changes/` até serem sincronizadas/arquivadas.

---

## ⚡ RTK

**Rust Token Killer** — economia de tokens (Claude **e** Codex).

Prefixe comandos com `rtk` para sair compacto (Claude usa hook automático; no Codex o
`RTK.md` instrui o agente a usar `rtk`).

```bash
rtk git status        # status compacto
rtk git diff          # diff compacto (~80% menos tokens)
rtk cargo test        # só falhas (90%)
rtk pytest            # só falhas (90%)
rtk go test           # só falhas (90%)
rtk ls <path>         # árvore compacta
rtk grep <padrão>     # agrupado por arquivo
rtk gain              # estatística de economia
rtk init --show       # ver config atual
```

---

## 🪨 Caveman

Token-saver (Claude plugin + Codex skills).

```text
/caveman             # ativa o modo caveman na sessão (saída ultra-compacta)
/caveman-review      # review de PR em uma linha, com emoji
/caveman-commit      # mensagem de commit convencional curta
$caveman             # menção da skill (Codex)
```

No Claude Code ativa via plugin (hook de sessão); no Codex via skills em `.agents/skills/caveman*`.

---

## ✅ Qualidade

Java 25, via `scripts/quality/`:

```bash
bash scripts/quality/verify-all.sh --fast   # format-check, checkstyle, unit, package-rules
bash scripts/quality/verify-all.sh --full    # + integration, bdd, jacoco, pit, archunit
bash scripts/quality/format.sh               # Spotless (aplica)
bash scripts/quality/checkstyle.sh           # Checkstyle Java 25
bash scripts/quality/jacoco.sh               # cobertura >= 90%
bash scripts/quality/mutation-test.sh        # PIT >= 90%
bash scripts/quality/archunit.sh             # regras de arquitetura
bash scripts/quality/test-unit.sh            # testes unitários
bash scripts/quality/test-integration.sh     # testes de integração
bash scripts/quality/test-bdd.sh             # BDD
```

Gate ausente é **reportado como ausente** (não falha). Habilitar plugins:
`config/pom-quality-plugins.example.xml`.

---

## 🧪 Teste de carga

```bash
# k6 (script em JS) — dashboard web embutido, sem Grafana:
K6_WEB_DASHBOARD=true k6 run kit/examples/k6/smoke.js     # http://localhost:5665
k6 run kit/examples/k6/smoke.js

# JMeter (plano .jmx) — modo non-GUI:
jmeter -n -t plano.jmx -l resultado.jtl
```

---

## 📐 OpenSpec e relatórios

```bash
bash scripts/ai/detect-project.sh        # detecta build/linguagem/framework
bash scripts/ai/openspec-validate.sh     # specs × código
bash scripts/ai/opsx-context-check.sh    # contexto mínimo antes de implementar
bash scripts/ai/context-pack.sh          # empacota contexto (Repomix)
bash scripts/ai/task-report.sh           # relatório da tarefa
bash scripts/ai/validate-claude-agents.sh
bash scripts/ai/validate-codex-agents.sh
```

Cadeia: **PRD** (`docs/prd/`, skill `prd-produto`) → **OpenSpec change** (`/opsx propose`)
→ **SDD/design** → **TDD** → gates → report.

---

## 🔌 MCPs

Claude em `.mcp.json` · Codex em `~/.codex/config.toml`:

`context7` · `springdocs` · `aws-docs` · `terraform-registry` · `aws-pricing-sandbox` ·
`localstack-lab`. Registrados para os dois no DevContainer; no Claude, aprove na 1ª vez.
