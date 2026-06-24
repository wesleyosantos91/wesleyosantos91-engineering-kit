# Dev Container

Este devcontainer usa uma imagem Linux oficial de devcontainers com Java 25 e evita configurações específicas de IDE. Ele pode ser aberto por qualquer cliente compatível com a especificação Dev Containers, incluindo IntelliJ IDEA e VS Code.

Ferramentas instaladas no `postCreateCommand`:

- Java 25, via imagem `mcr.microsoft.com/devcontainers/java:25-bookworm`.
- Maven, reforcado no `postCreateCommand` caso `mvn` ainda nao esteja disponivel.
- Node.js 22, npm, Python e pipx, reforcados no `postCreateCommand` caso ainda nao estejam disponiveis.
- Codex: `@openai/codex`.
- Claude Code: `@anthropic-ai/claude-code`.
- AGY, Google Antigravity CLI: configuravel via `AGY_INSTALL_COMMAND`.
- OpenSpec: `@fission-ai/openspec@latest`.
- RTK: instalado pelo script oficial do `rtk-ai/rtk`.
- Repomix, para contexto de IA do repositorio: `repomix`.

Depois da instalacao, o `postCreateCommand` tenta inicializar as tres ferramentas dentro do repositorio:

- OpenSpec: `openspec init --tools codex,claude --force`, salvo se `openspec` ja existir.
- RTK: `rtk init --codex`, salvo se `RTK.md` ja existir.
- Repomix: `printf 'y\n' | repomix --init`, salvo se `repomix.config.json` ja existir.

Os nomes dos pacotes podem ser alterados sem editar o script, definindo variáveis de ambiente antes do `postCreateCommand`:

- `CODEX_NPM_PACKAGE`
- `CLAUDE_CODE_NPM_PACKAGE`
- `AGY_INSTALL_COMMAND`
- `OPEN_SPEC_NPM_PACKAGE`
- `REPOMIX_NPM_PACKAGE`
- `OPEN_SPEC_INIT_COMMAND`
- `RTK_INIT_COMMAND`
- `REPOMIX_INIT_COMMAND`
- `OPEN_SPEC_MARKER`
- `RTK_MARKER`
- `REPOMIX_MARKER`
