#!/usr/bin/env bash
# EXEMPLO de hook (não ativo por padrão). Bloqueia comandos destrutivos.
# Uso com Claude Code: PreToolUse(Bash). Lê o comando em $1 ou em $TOOL_INPUT.
# Sai com código !=0 para BLOQUEAR.
set -euo pipefail

cmd="${1:-${TOOL_INPUT:-}}"
patterns='rm[[:space:]]+-rf|git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+clean[[:space:]]+-fdx|docker[[:space:]]+system[[:space:]]+prune|drop[[:space:]]+database|terraform[[:space:]]+apply|kubectl[[:space:]]+delete|aws[[:space:]].*delete'

if printf '%s' "$cmd" | grep -qiE "$patterns"; then
  echo "[hook] BLOQUEADO: comando destrutivo detectado: $cmd" >&2
  echo "[hook] Confirme explicitamente com um humano antes de executar." >&2
  exit 2
fi
exit 0
