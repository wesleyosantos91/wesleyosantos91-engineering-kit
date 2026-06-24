# wesleyosantos91-engineering-kit

Meu **kit de engenharia** reutilizável: skills, agents, commands, hooks, DevContainer,
quality gates (Java 25), MCPs e scripts que uso no dia a dia — empacotados para serem
consumidos por **qualquer projeto** como um **git submodule**.

> **Objetivo:** parar de reconfigurar o ambiente do zero a cada projeto/máquina nova.
> Adiciono o kit uma vez, e mantenho **uma fonte única**: ao evoluir o kit, todos os
> repositórios que o usam recebem a atualização com um comando — sem recopiar nada.

Projeto **independente e autossuficiente** — não depende de nenhum outro repositório.
O escopo é **só configuração**: harness de IA + DevContainer poliglota + ferramentas.
**Sem** código de aplicação.

### DevContainer — tudo pronto para estudar, fazer POCs e desenvolver

O DevContainer já sobe com as toolchains que uso no dia a dia:

| Toolchain | Como vem |
|---|---|
| **Java 25** (Temurin) | feature do devcontainer |
| **Python 3.12** + `uv` | feature + `install-tools.sh` |
| **Go** | feature do devcontainer |
| **Rust** (cargo/rustup) | feature do devcontainer |
| **Terraform** | feature do devcontainer |
| **AWS CLI** | feature do devcontainer |
| **JMeter** | `install-tools.sh` (Apache JMeter) |
| **k6** | `install-tools.sh` (teste de carga; dashboard web embutido, sem Grafana) |
| Node 22, Docker-in-Docker | features do devcontainer |
| Claude Code, Codex, RTK, OpenSpec, Repomix + MCPs | `install-tools.sh` (RTK/OpenSpec já iniciados) |
| **Caveman** (+ `caveman-review`) | `install-tools.sh` (token-saver, instalado e iniciado) |

---

## Como funciona (a "fonte única")

O segredo é **symlink**:

- Tudo que é **estável** (skills, agents, commands, hooks, scripts, devcontainer,
  quality configs) é **symlinkado** do submódulo para a raiz do seu projeto.
  → Atualizou o kit? `git submodule update --remote` e os symlinks **já apontam** para
  o novo conteúdo. **Você não recopia nada.**
- Os poucos arquivos que precisam de valor por-projeto (`CLAUDE.md`, `AGENTS.md`,
  `.ai/harness.yaml`, `.devcontainer/devcontainer.json`,
  `config/pom-quality-plugins.example.xml`) são **copiados e personalizados**
  (substituindo `__BASE_PACKAGE__` / `__PROJECT_NAME__`) — ficam editáveis por você.

Detalhes e a tabela completa do que é symlink vs cópia: [`docs/architecture.md`](docs/architecture.md).

---

## Quickstart — só adicionar o submódulo e subir o DevContainer

**Você só faz isto. Mais nada:**

```bash
git submodule add https://github.com/wesleyosantos91/wesleyosantos91-engineering-kit .engineering-kit
git config -f .gitmodules submodule..engineering-kit.branch main   # rastrear o branch main
git add .gitmodules .engineering-kit && git commit -m "chore: adiciona engineering-kit"
```

Agora **abra no DevContainer**: VS Code → *Reopen in Container* → escolha a config
`.engineering-kit/kit/.devcontainer/devcontainer.json` (ou `devcontainer up`).

Ao subir, o `postCreateCommand` (`bootstrap.sh`) faz **tudo sozinho**:

1. **Aplica o kit na raiz do seu projeto** — `.claude/`, `.codex/`, `.agents/`, `.ai/`,
   `scripts/`, `.mcp.json`, etc. viram symlinks na raiz; `CLAUDE.md`, `AGENTS.md`,
   `.ai/harness.yaml`, `.devcontainer/devcontainer.json` são personalizados (o
   **base package é auto-detectado** do seu `src/main/java`).
2. **Instala as toolchains e CLIs** (Java/Python/Go/Rust/Terraform/AWS/JMeter/k6 +
   Claude Code, Codex, RTK, OpenSpec, Repomix, Caveman) e **registra os MCPs**.

Depois do 1º boot, a config também passa a existir em `.devcontainer/` na raiz, então
nas próximas vezes o *Reopen in Container* já acha direto.

> **Instalação manual (sem DevContainer):** se quiser aplicar na máquina host sem subir o
> container, rode `bash .engineering-kit/install.sh` (auto-detecta o base package; aceita
> `--base-package`/`--name`/`--force`). É o mesmo que o `bootstrap.sh` chama por baixo.

### Clone com tudo de uma vez

Depois do 1º boot os symlinks (inclusive `.devcontainer/`) ficam versionados, então quem
clonar o projeto **com submódulos** sobe com tudo:

```bash
git clone --recurse-submodules https://github.com/voce/seu-projeto.git
# abra no VS Code -> "Reopen in Container"
```

> Clonou sem `--recurse-submodules`? `git submodule update --init --recursive` e reabra o
> container. No Windows sem Developer Mode, ver [`docs/windows.md`](docs/windows.md).

Passo a passo detalhado: [`docs/getting-started.md`](docs/getting-started.md).

> **Windows:** symlinks exigem **Developer Mode** ligado (ou rodar o `install.sh`
> dentro do DevContainer, que é Linux). Veja [`docs/windows.md`](docs/windows.md).

---

## Atualizar o kit (puxar a evolução)

```bash
# dentro do projeto consumidor
bash .engineering-kit/update.sh                 # = submodule update --remote + re-checa symlinks
git add .engineering-kit && git commit -m "chore: bump engineering-kit"
```

Os configs symlinkados refletem o novo conteúdo na hora. O `install.sh` só é re-executado
para criar symlinks de **itens novos** que o kit passou a oferecer. Mais em
[`docs/updating.md`](docs/updating.md).

---

## Scripts

| Script | O que faz |
|---|---|
| `install.sh`   | Cria os symlinks e personaliza os arquivos por-projeto no repo alvo. Flags: `--base-package`, `--name`, `--force`, `--target`. |
| `update.sh`    | `git submodule update --remote --merge` + re-checagem de symlinks novos. |
| `uninstall.sh` | Remove os symlinks e o bloco do `.gitignore`. `--purge-copies` remove também os arquivos copiados. |

---

## O que vem no kit (`kit/`)

| Caminho | Conteúdo |
|---|---|
| `.claude/`    | agents, commands, **skills** (inclui `prd-produto`), `settings.example.json` |
| `.codex/`     | agents, skills, `config.example.toml`, perfis MCP |
| `.agents/`    | skills para o Codex (espelho das skills) |
| `.ai/`        | rules, prompts, references, templates, `harness.yaml` |
| `.devcontainer/` | DevContainer poliglota (Java/Python/Go/Rust/Terraform/AWS/JMeter) + `install-tools.sh` (CLIs e MCPs) |
| `scripts/`    | `ai/`, `quality/`, **`hooks/`**, `lib/`, `mcp/` |
| `config/`     | checkstyle (Java 25), spotless, archunit, pitest, plugins de pom |
| `docs/ai-harness/` | documentação do harness (agents, skills, MCP, quality gates, OpenSpec/SDD) |
| `.mcp.json`, `openspec/config.yaml`, `compose.yaml`, `infra/localstack/` | MCPs, OpenSpec, lab LocalStack |

### O que **NÃO** vem (de propósito)
- Código de aplicação (`src/`, `pom.xml`, `mvnw`) — cada projeto traz o seu.
- Estado local/gerado: `.ai/reports/*`, `.claude/settings.local.json`, `.codex/config.toml`, `**/.terraform/`.
- Qualquer secret. Tokens/credenciais vêm sempre de variáveis de ambiente (`.env`, nunca commitado).

---

## Evoluir o kit

Edite o payload em `kit/` e rode os validadores antes de commitar:

```bash
cd kit
bash scripts/ai/validate-skills.sh
bash scripts/ai/validate-claude-agents.sh
bash scripts/ai/validate-codex-agents.sh
```

Projetos que usam o kit puxam a evolução com `bash .engineering-kit/update.sh`.

---

## Licença

**CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0) —
ver [`LICENSE`](LICENSE).

- **BY** — credite **Wesley Oliveira Santos** e referencie este projeto.
- **NC** — proibido uso comercial / venda.
- **SA** — derivados devem manter esta mesma licença e o código aberto.
