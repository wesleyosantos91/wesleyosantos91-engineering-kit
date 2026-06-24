# Dev Container

DevContainer poliglota sobre a imagem Linux oficial `mcr.microsoft.com/devcontainers/base:ubuntu-22.04`,
sem configurações específicas de IDE. Pode ser aberto por qualquer cliente compatível com a
especificação Dev Containers (VS Code, IntelliJ IDEA, etc.).

Toolchains via **features** do devcontainer (versão pinada, independente do distro base):

- **Java 25** (Temurin) · **Python 3.12** · **Go** · **Rust** (rustup/cargo).
- **Terraform** · **AWS CLI**.
- **Node.js 22** · **Docker-in-Docker**.

Ferramentas instaladas no `postCreateCommand` (`install-tools.sh`):

- **JMeter** (Apache JMeter — teste de carga; versão via `JMETER_VERSION`, default 5.6.3).
- **k6** (teste de carga; binário da última release. Dashboard web embutido:
  `K6_WEB_DASHBOARD=true k6 run script.js` → porta 5665. Exemplo em `examples/k6/`).
- **uv** (Astral) para Python.
- Codex: `@openai/codex`.
- Claude Code: `@anthropic-ai/claude-code`.
- OpenSpec: `@fission-ai/openspec@latest` (iniciado com `openspec init`).
- RTK: script oficial do `rtk-ai/rtk` (iniciado com `rtk init -g`).
- **Caveman** (+ `caveman-review`): token-saver para Claude Code/Codex, instalado e
  iniciado (`--with-init`).
- Repomix, para contexto de IA do repositório: `repomix`.
- Registro dos MCPs do Codex (`scripts/mcp/*`).

Depois da instalacao, o `postCreateCommand` tenta inicializar as tres ferramentas dentro do repositorio:

- OpenSpec: `openspec init --tools codex,claude --force`, salvo se `openspec` ja existir.
- RTK: `rtk init --codex`, salvo se `RTK.md` ja existir.
- Repomix: `printf 'y\n' | repomix --init`, salvo se `repomix.config.json` ja existir.

Os nomes dos pacotes podem ser alterados sem editar o script, definindo variáveis de ambiente antes do `postCreateCommand`:

- `CODEX_NPM_PACKAGE`
- `CLAUDE_CODE_NPM_PACKAGE`
- `JMETER_VERSION`
- `OPEN_SPEC_NPM_PACKAGE`
- `REPOMIX_NPM_PACKAGE`
- `OPEN_SPEC_INIT_COMMAND`
- `RTK_INIT_COMMAND`
- `REPOMIX_INIT_COMMAND`
- `OPEN_SPEC_MARKER`
- `RTK_MARKER`
- `REPOMIX_MARKER`
