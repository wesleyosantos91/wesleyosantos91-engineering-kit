# wesleyosantos91-engineering-kit

Meu **kit de engenharia** reutilizável: skills, agents, commands, hooks, DevContainer,
quality gates (Java 25), MCPs e scripts que uso no dia a dia — empacotados para serem
consumidos por **qualquer projeto** como um **git submodule**.

> **Objetivo:** parar de reconfigurar o ambiente do zero a cada projeto/máquina nova.
> Adiciono o kit uma vez, e mantenho **uma fonte única**: ao evoluir o kit, todos os
> repositórios que o usam recebem a atualização com um comando — sem recopiar nada.

Baseado no [`ai-harness-chassis`](https://github.com/wesleyosantos91/ai-harness-chassis)
(payload de configuração) — **sem** código de aplicação (nenhum projeto Spring). O
escopo aqui é **só configuração**: harness de IA + DevContainer + ferramentas.

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

## Quickstart

```bash
# 1. adicionar o kit como submódulo (ex.: em .engineering-kit)
git submodule add https://github.com/wesleyosantos91/wesleyosantos91-engineering-kit .engineering-kit
git config -f .gitmodules submodule..engineering-kit.branch main   # rastrear o branch main

# 2. aplicar no projeto (cria symlinks + personaliza os arquivos por-projeto)
bash .engineering-kit/install.sh --base-package com.acme.orders --name orders

# 3. versionar o ponteiro do submódulo
git add .gitmodules .engineering-kit CLAUDE.md AGENTS.md
git commit -m "chore: adiciona engineering-kit"
```

Depois: abra o projeto no **DevContainer** ("Reopen in Container"). O
`postCreateCommand` instala Claude Code, Codex, RTK, OpenSpec, Repomix, `uv` e registra
os MCPs automaticamente.

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
| `.devcontainer/` | imagem/features + `install-tools.sh` (instala CLIs e MCPs) |
| `scripts/`    | `ai/`, `quality/`, **`hooks/`**, `lib/`, `mcp/` |
| `config/`     | checkstyle (Java 25), spotless, archunit, pitest, plugins de pom |
| `docs/ai-harness/` | documentação do harness (agents, skills, MCP, quality gates, OpenSpec/SDD) |
| `.mcp.json`, `openspec/config.yaml`, `compose.yaml`, `infra/localstack/` | MCPs, OpenSpec, lab LocalStack |

### O que **NÃO** vem (de propósito)
- Código de aplicação (`src/`, `pom.xml`, `mvnw`) — cada projeto traz o seu.
- Estado local/gerado: `.ai/reports/*`, `.claude/settings.local.json`, `.codex/config.toml`, `**/.terraform/`.
- Qualquer secret. Tokens/credenciais vêm sempre de variáveis de ambiente (`.env`, nunca commitado).

---

## Atualizar o kit a partir do `ai-harness-chassis`

O payload em `kit/` é um espelho de `ai-harness-chassis/template/`. Para trazer evoluções
do chassi: recopie `template/` para `kit/`, renomeie `gitignore.chassis` → `gitignore.kit`,
e mantenha os arquivos com placeholder intactos (o `install.sh` os detecta sozinho). Rode
os validadores antes de commitar:

```bash
cd kit
bash scripts/ai/validate-skills.sh
bash scripts/ai/validate-claude-agents.sh
bash scripts/ai/validate-codex-agents.sh
```

---

## Licença

A definir. _(O `ai-harness-chassis` não declara licença; o `setup-init` usa CC BY-NC-SA 4.0.
Defina antes de tornar o repositório público.)_
