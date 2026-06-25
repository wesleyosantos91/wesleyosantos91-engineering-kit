# 🚀 Getting Started

[![⬅ README](https://img.shields.io/badge/⬅-README-1f6feb?style=flat-square)](../README.md)
[![CC BY-SA 4.0](https://img.shields.io/badge/license-CC%20BY--SA%204.0-1f6feb?style=flat-square)](../LICENSE)

**📖 Docs:** [Comandos](commands.md) · **Getting Started** · [Atualizar](updating.md) · [Arquitetura](architecture.md) · [Windows](windows.md)

Guia passo a passo para consumir o `wesleyosantos91-engineering-kit` como submódulo.

## 📑 Índice

- [Pré-requisitos](#pré-requisitos)
- [Passo 1 — adicionar o submódulo](#passo-1--adicionar-o-submódulo)
- [Passo 2 — popular a raiz (bootstrap)](#passo-2--popular-a-raiz-bootstrap)
- [Passo 3 — versionar](#passo-3--versionar)
- [Passo 4 — abrir no DevContainer](#passo-4--abrir-no-devcontainer)
- [Passo 5 — clones futuros](#passo-5--clones-futuros-do-projeto)
- [Verificação rápida](#verificação-rápida)

---

## Pré-requisitos

- `git` (com submódulos).
- Para abrir no container: Docker + VS Code com a extensão *Dev Containers* (ou a CLI
  `devcontainer`).
- **Symlinks** habilitados onde você roda o `bootstrap.sh`:
  - **Linux/macOS / DevContainer:** nativo (recomendado).
  - **Windows (Git Bash):** ativar **Developer Mode** — ver [`windows.md`](windows.md).

---

## Passo 1 — adicionar o submódulo

```bash
cd /caminho/do/seu/projeto
git submodule add https://github.com/wesleyosantos91/wesleyosantos91-engineering-kit .engineering-kit
git config -f .gitmodules submodule..engineering-kit.branch main   # rastrear main
```

## Passo 2 — popular a raiz (bootstrap)

```bash
bash .engineering-kit/bootstrap.sh
```

O `bootstrap.sh` (dentro do submódulo):

1. **Popula a raiz** do projeto: `.claude/`, `.codex/`, `.agents/`, `.ai/`, `scripts/`,
   `.mcp.json`, `openspec/`, etc. viram **symlinks** apontando pro submódulo; e
   `CLAUDE.md`, `AGENTS.md`, `.ai/harness.yaml`, `.devcontainer/devcontainer.json`,
   `config/pom-quality-plugins.example.xml` são **copiados e personalizados**.
2. O **base package é auto-detectado** do seu `src/main/java` (declaração `package` do
   1º `.java`). Para forçar: `bash .engineering-kit/bootstrap.sh --base-package com.acme.app --name app`.
3. Se rodado **dentro do DevContainer**, também instala as toolchains/CLIs (ver Passo 4).

| Flag | Default | Uso |
|---|---|---|
| `--base-package <pkg>` | auto-detectado (ou `com.example`) | base package Java do scaffold. |
| `--name <nome>` | nome da pasta | nome do projeto / do container. |
| `--force` | — | sobrescreve symlinks/arquivos existentes. |
| `--target <dir>` | superprojeto do submódulo | alvo explícito (raro). |

> Pode pular este passo: se só fizer `git submodule add` e subir o DevContainer, o
> `postCreate` roda o `bootstrap.sh` e popula a raiz **e** instala as ferramentas de uma vez.

## Passo 3 — versionar

```bash
git add -A && git commit -m "chore: adiciona engineering-kit"
```

> Os **symlinks** entram no commit (o git versiona o link). Quem clonar precisa inicializar
> o submódulo (Passo 5).

## Passo 4 — abrir no DevContainer

VS Code: **"Reopen in Container"** → escolha a config
`.engineering-kit/kit/.devcontainer/devcontainer.json` (ou `devcontainer up`).

O `postCreate` (`bootstrap.sh`) instala e inicia:

- **Toolchains**: Java 25 + Maven + Gradle · Python 3.12 + `uv` · Go · Rust · Terraform ·
  AWS CLI · Node 22 · Docker-in-Docker.
- **Teste de carga**: JMeter · k6 (dashboard web embutido na porta 5665).
- **IA**: Claude Code · Codex · OpenSpec · Repomix · **RTK** (Claude E Codex) ·
  **Caveman** (+ `caveman-review`). MCPs registrados para os dois.

Depois:
- **Claude Code:** aprove os MCPs do projeto na 1ª vez (`.mcp.json`).
- **Secrets:** `cp .env.example .env` e preencha (nunca commite o `.env`).

## Passo 5 — clones futuros do projeto

```bash
git clone --recurse-submodules <seu-projeto>
# OU, se já clonou sem submódulos:
git submodule update --init --recursive
bash .engineering-kit/bootstrap.sh   # recria symlinks (não sobrescreve seus arquivos)
```

---

## Verificação rápida

```bash
# symlinks apontando p/ o submódulo
ls -l .claude .codex .agents scripts        # -> .engineering-kit/kit/...

# skills disponíveis (Claude nativo + Codex auto-discovery em .agents/skills/)
ls .claude/skills .agents/skills

# nenhum placeholder restante nos arquivos copiados
grep -rIl --exclude-dir=.git -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' . | grep -v '^\./.engineering-kit/'
# (saída vazia = OK)
```

Próximos: [`commands.md`](commands.md) (atalhos) · [`updating.md`](updating.md) ·
[`architecture.md`](architecture.md) · [`windows.md`](windows.md).
