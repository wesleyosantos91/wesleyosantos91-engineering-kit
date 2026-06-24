#!/usr/bin/env bash
# ============================================================================
# postCreate do DevContainer — orquestra o setup completo do projeto.
#
# Fluxo desejado pelo usuário:
#   1. git submodule add <kit> .engineering-kit   (e nada mais)
#   2. abrir o DevContainer  ->  ESTE script roda no postCreate e:
#        a) aplica o kit na RAIZ do projeto (symlinks .claude/.codex/.agents/...
#           + scaffold de CLAUDE.md/AGENTS.md/.ai/harness.yaml/devcontainer.json)
#        b) instala as toolchains/CLIs e registra os MCPs (install-tools.sh)
#
# Idempotente: reabrir o container não duplica nada.
# ============================================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # <kit>/kit/.devcontainer
KIT_REPO_ROOT="$(cd "$HERE/../.." && pwd)"             # <kit>  (raiz do repo do kit)
PROJECT_ROOT="$(pwd)"                                  # workspace (raiz do projeto, se submódulo)

if [ "$KIT_REPO_ROOT" != "$PROJECT_ROOT" ]; then
  echo "[bootstrap] kit como submódulo — aplicando configs na raiz: $PROJECT_ROOT"
  bash "$KIT_REPO_ROOT/install.sh" --target "$PROJECT_ROOT" "$@"
  cd "$PROJECT_ROOT"
  RUN_DIR="$PROJECT_ROOT"
else
  echo "[bootstrap] kit standalone — sem symlink; instalando ferramentas no payload"
  cd "$KIT_REPO_ROOT/kit"
  RUN_DIR="$KIT_REPO_ROOT/kit"
fi

# install-tools.sh espera rodar de um diretório que tenha scripts/, .mcp.json etc.
# (na raiz do projeto eles já existem como symlink após o install.sh).
echo "[bootstrap] instalando toolchains/CLIs (install-tools.sh) em: $RUN_DIR"
bash "$RUN_DIR/.devcontainer/install-tools.sh"

echo "[bootstrap] concluído."
