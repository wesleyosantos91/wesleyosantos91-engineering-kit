# Uso com Claude Code

Claude Code lê `CLAUDE.md` (enxuto) + slash-commands em `.claude/commands/`.

## Setup

- O DevContainer instala o Claude Code (`.devcontainer/install-tools.sh`).
- RTK inicializado (`rtk init -g`) → hook global + `~/.claude/RTK.md`.
- `.claude/settings.example.json` traz allow/deny sugeridos (copie para
  `.claude/settings.local.json` e ajuste; **não** aplicado automaticamente).

## Slash-commands

| Comando | Ação |
|---|---|
| `/plan <tarefa>` | Diagnóstico e plano, sem editar código |
| `/implement-tdd <tarefa>` | Implementa com TDD obrigatório |
| `/review` | Revisa o diff atual |
| `/debug <erro>` | Analisa erro preservando stack trace |
| `/quality [fast\|full\|coverage\|mutation\|arch\|openspec]` | Roda gates |
| `/openspec-check <tarefa>` | Compara implementação com spec |
| `/context-pack` | Empacota contexto econômico |

Os comandos OpenSpec existentes (`.claude/commands/opsx/`) seguem disponíveis.

## Headroom

- Contexto cirúrgico; `/compact` quando necessário; resuma logs mantendo stack trace.
- `bash scripts/ai/context-pack.sh` para um snapshot enxuto do repo.

## Nunca

Comandos destrutivos sem confirmação, exposição de secrets, alteração arriscada de
`pom.xml`, deleção de arquivos, reestruturação de pacotes sem aprovação (`.ai/rules/security.md`).
