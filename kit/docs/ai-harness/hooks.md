# Hooks

Exemplos de hooks em `scripts/hooks/`. **Nenhum é ativado automaticamente** — você
ativa manualmente. São defensivos (segurança/qualidade), nunca destrutivos.

| Hook | Quando | Efeito |
|---|---|---|
| `block-dangerous-commands.sh` | PreToolUse(Bash) | Bloqueia `rm -rf`, `git reset --hard`, `terraform apply`, `kubectl delete`, `aws *delete*`… (exit 2) |
| `prevent-secret-leak.sh` | PreToolUse(Write/Edit) ou pre-commit | Bloqueia conteúdo com secrets (exit 2) |
| `post-edit-format-check.sh` | PostToolUse(Edit/Write) | Avisa se a formatação está fora (não bloqueia) |
| `post-task-quality-summary.sh` | Stop/SubagentStop | Gera `.ai/reports/quality-summary.md` |
| `openspec-context-guard.sh` | PreToolUse(Edit em src/main) | Exige contexto mínimo de OpenSpec/tarefa (exit 2) |

## Ativar no Claude Code (manual)

Copie `.claude/settings.example.json` para `.claude/settings.local.json` e adicione
um bloco `hooks`. Exemplo (PreToolUse de Bash):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash scripts/hooks/block-dangerous-commands.sh" }
        ]
      }
    ]
  }
}
```

> Hooks recebem o contexto via stdin/variáveis do harness; os exemplos leem o comando
> de `$1`/`$TOOL_INPUT` e o arquivo de `$1`. Ajuste conforme sua versão do Claude Code.

## Ativar no Codex (manual)

No `.codex/config.toml` (cópia de `.codex/config.example.toml`), os hooks ficam
**desativados** (`[features] hooks = false`). Habilitar é opt-in e específico da sua
versão do Codex CLI. Mantenha desativado por padrão.

## Regras

- Hooks são **exemplos**; revise antes de ativar.
- Nunca commitar hooks que executem comandos destrutivos ou exponham secrets.
- Hooks de bloqueio devem sair com código != 0 para impedir a ação.
