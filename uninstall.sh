#!/usr/bin/env bash
# ============================================================================
# wesleyosantos91-engineering-kit — uninstall
#
# Remove o que o install.sh criou no projeto alvo:
#   - symlinks que apontam para dentro do submódulo do kit;
#   - o bloco marcado do .gitignore.
#
# Por padrão NÃO remove os arquivos copiados+substituídos (CLAUDE.md, AGENTS.md,
# .ai/harness.yaml, devcontainer.json, pom-quality-plugins...): eles foram
# editados por você. Use --purge-copies para remover também esses.
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYLOAD="$SCRIPT_DIR/kit"

TARGET=""
PURGE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --target)        TARGET="${2:-}"; shift 2 ;;
    --purge-copies)  PURGE=1; shift ;;
    -h|--help)       echo "Uso: uninstall.sh [--target <dir>] [--purge-copies]"; exit 0 ;;
    *)               echo "Argumento inesperado: $1" >&2; exit 2 ;;
  esac
done

if [ -z "$TARGET" ]; then
  TARGET="$(git -C "$SCRIPT_DIR" rev-parse --show-superproject-working-tree 2>/dev/null || true)"
  [ -z "$TARGET" ] && TARGET="$(dirname "$SCRIPT_DIR")"
fi
TARGET="$(cd "$TARGET" && pwd)"
echo "Alvo: $TARGET"; echo

REMOVED=0
# Remove symlinks cujo destino resolve para dentro do payload do kit.
while IFS= read -r -d '' link; do
  resolved="$(realpath -m "$link" 2>/dev/null || true)"
  case "$resolved" in
    "$PAYLOAD"|"$PAYLOAD"/*)
      rm "$link"; echo "  removido symlink: ${link#$TARGET/}"; REMOVED=$((REMOVED+1)) ;;
  esac
done < <(find "$TARGET" -path "$SCRIPT_DIR" -prune -o -type l -print0)

if [ "$PURGE" -eq 1 ]; then
  while IFS= read -r -d '' src; do
    rel="${src#$PAYLOAD/}"
    if grep -qI -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' "$src" 2>/dev/null; then
      dst="$TARGET/$rel"
      [ -f "$dst" ] && { rm "$dst"; echo "  removido copiado: $rel"; REMOVED=$((REMOVED+1)); }
    fi
  done < <(find "$PAYLOAD" -type f -print0)
fi

# Remove o bloco marcado do .gitignore.
GI="$TARGET/.gitignore"
if [ -f "$GI" ] && grep -qF "# >>> engineering-kit (managed) >>>" "$GI"; then
  sed -i '/# >>> engineering-kit (managed) >>>/,/# <<< engineering-kit (managed) <<</d' "$GI"
  # remove linha em branco final eventualmente deixada
  echo "  bloco do kit removido do .gitignore"
fi

echo; echo "✅ Uninstall concluído. Itens removidos: $REMOVED"
echo "   (o submódulo em si continua; remova com 'git submodule deinit' se desejar)"
