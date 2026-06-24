# Getting Started — adicionar o kit a um projeto

Guia passo a passo para consumir o `wesleyosantos91-engineering-kit` como submódulo.

## Pré-requisitos

- `git` (com submódulos).
- **Symlinks habilitados** no ambiente onde você roda o `install.sh`:
  - **Linux/macOS / DevContainer:** nativo, nada a fazer (recomendado).
  - **Windows (Git Bash):** ativar **Developer Mode** — veja [`windows.md`](windows.md).
- Para abrir no container: Docker + VS Code com a extensão *Dev Containers* (ou a CLI
  `devcontainer`).

---

## Passo 1 — adicionar o submódulo

Escolha um caminho para o submódulo (sugestão: `.engineering-kit`):

```bash
cd /caminho/do/seu/projeto
git submodule add https://github.com/wesleyosantos91/wesleyosantos91-engineering-kit .engineering-kit
```

Faça o submódulo **rastrear o branch `main`** (para que `update --remote` pegue o topo):

```bash
git config -f .gitmodules submodule..engineering-kit.branch main
```

## Passo 2 — rodar o install

```bash
bash .engineering-kit/install.sh --base-package com.acme.orders --name orders
```

Flags:

| Flag | Default | Uso |
|---|---|---|
| `--base-package <pkg>` | `com.example` | base package Java usado no scaffold de `CLAUDE.md`, `AGENTS.md`, `.ai/harness.yaml`, `pom-quality-plugins`. |
| `--name <nome>` | nome da pasta do projeto | nome do projeto (e do container no `devcontainer.json`). |
| `--target <dir>` | superprojeto do submódulo | alvo explícito (raro; o script detecta sozinho). |
| `--force` | — | sobrescreve symlinks/arquivos já existentes. |

O que o install faz:

1. **Symlinka** o que é estável (`.claude/`, `.codex/`, `.agents/`, `scripts/`,
   `docs/`, `.mcp.json`, `openspec/`, partes estáveis de `.ai/`, `.devcontainer/`, `config/`).
2. **Copia e personaliza** os arquivos com placeholder
   (`CLAUDE.md`, `AGENTS.md`, `.ai/harness.yaml`, `.devcontainer/devcontainer.json`,
   `config/pom-quality-plugins.example.xml`).
3. Marca os `*.sh` como executáveis.
4. Aplica um bloco gerenciado no `.gitignore` do projeto.

## Passo 3 — versionar

```bash
git add .gitmodules .engineering-kit CLAUDE.md AGENTS.md .ai/harness.yaml .gitignore
git commit -m "chore: adiciona engineering-kit"
```

> Os **symlinks** também entram no commit (o git versiona o link, não o conteúdo). Quem
> clonar o projeto precisa inicializar o submódulo (Passo 5).

## Passo 4 — abrir no DevContainer

No VS Code: **"Reopen in Container"** (ou `devcontainer up --workspace-folder .`).
O `postCreateCommand`/`install-tools.sh` instala Claude Code, Codex, RTK, OpenSpec,
Repomix, `uv` e **registra os MCPs do Codex**.

Depois:
- **Claude Code:** na 1ª vez, aprove os MCPs do projeto (definidos em `.mcp.json`).
- **Secrets:** `cp .env.example .env` e preencha (ex.: `LOCALSTACK_AUTH_TOKEN`). Nunca
  commite o `.env` (já ignorado).

## Passo 5 — clones futuros do projeto

Quem clonar o projeto depois precisa trazer o submódulo e re-aplicar:

```bash
git clone <seu-projeto>
cd <seu-projeto>
git submodule update --init --recursive
bash .engineering-kit/install.sh    # recria symlinks locais (não sobrescreve os copiados)
```

---

## Verificação rápida

```bash
# symlinks apontando p/ dentro do submódulo
ls -l .claude .codex scripts        # devem mostrar -> .engineering-kit/kit/...

# skill nova disponível
ls .claude/skills/prd-produto/

# nenhum placeholder restante nos arquivos copiados
grep -rIl --exclude-dir=.git -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' . | grep -v '^\./.engineering-kit/'
# (saída vazia = OK)
```

Próximos: [`updating.md`](updating.md) · [`architecture.md`](architecture.md) · [`windows.md`](windows.md).
