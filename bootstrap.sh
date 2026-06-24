#!/usr/bin/env bash
# ============================================================================
# engineering-kit — bootstrap (rode a partir do submódulo)
#
# Popula a RAIZ do projeto consumidor com os configs do kit (symlinks + scaffold)
# e, quando rodando DENTRO de um DevContainer/Codespace, instala as toolchains/CLIs.
#
# Uso típico:
#   git submodule add <kit> .engineering-kit
#   bash .engineering-kit/bootstrap.sh        # popula a raiz (.claude/.agents/...)
#   # abrir o DevContainer -> este mesmo bootstrap roda no postCreate e instala
#   # as ferramentas (e garante os symlinks).
#
# Atualizar depois:
#   git submodule update --remote .engineering-kit
#   -> skills/configs novas aparecem automaticamente (são symlinks p/ o submódulo).
#      Só um diretório de TOPO novo exige rodar o bootstrap de novo.
# ============================================================================
set -euo pipefail

# No Git Bash/Windows força symlink nativo (exige Developer Mode); inócuo em Linux.
export MSYS=winsymlinks:nativestrict

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Descobre a raiz do projeto consumidor (superprojeto do submódulo, ou pasta-pai).
PROJECT_ROOT="$(git -C "$KIT_ROOT" rev-parse --show-superproject-working-tree 2>/dev/null || true)"
[ -z "$PROJECT_ROOT" ] && PROJECT_ROOT="$(dirname "$KIT_ROOT")"
PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"

if [ "$PROJECT_ROOT" = "$KIT_ROOT" ]; then
  echo "ERRO: rode o bootstrap a partir do projeto que usa o kit como submódulo." >&2
  echo "      Ex.: bash .engineering-kit/bootstrap.sh" >&2
  exit 1
fi

echo "==> [1/2] Populando a raiz do projeto com os configs: $PROJECT_ROOT"
bash "$KIT_ROOT/install.sh" --target "$PROJECT_ROOT" "$@"

# Dentro de container (DevContainer/Codespaces): instala toolchains/CLIs e MCPs.
if [ -f /.dockerenv ] || [ -n "${REMOTE_CONTAINERS:-}" ] || [ -n "${CODESPACES:-}" ]; then
  echo "==> [2/2] Container detectado: instalando toolchains/CLIs (install-tools.sh)"
  ( cd "$PROJECT_ROOT" && bash "$PROJECT_ROOT/.devcontainer/install-tools.sh" )
else
  echo "==> [2/2] Fora de container: raiz populada. As ferramentas (Java/Go/Rust/k6/"
  echo "          Claude Code/Codex/...) serão instaladas ao subir o DevContainer."
fi

echo "==> bootstrap concluído."
