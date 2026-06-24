#!/usr/bin/env bash
# ============================================================================
# wesleyosantos91-engineering-kit — update
#
# Conveniência rodada DENTRO do projeto consumidor: puxa o topo do branch
# rastreado do kit (fonte única) e re-checa os symlinks (cria os que faltarem
# por terem surgido novos itens de config no kit).
#
# Configs já symlinkados refletem o novo conteúdo automaticamente após o
# `git submodule update --remote` — esta etapa só cuida de itens NOVOS.
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SUPER="$(git -C "$SCRIPT_DIR" rev-parse --show-superproject-working-tree 2>/dev/null || true)"
[ -z "$SUPER" ] && SUPER="$(dirname "$SCRIPT_DIR")"
# Normaliza para o formato de caminho do shell (evita mismatch C:/ vs /c/ no Windows).
SUPER="$(cd "$SUPER" && pwd)"

# Caminho do submódulo relativo ao superprojeto (ex.: .engineering-kit)
SUB_REL="$(realpath -m --relative-to="$SUPER" "$SCRIPT_DIR")"

echo "Superprojeto:  $SUPER"
echo "Submódulo:     $SUB_REL"
echo

echo "[1/2] git submodule update --remote --merge $SUB_REL"
git -C "$SUPER" submodule update --remote --merge "$SUB_REL"

echo "[2/2] Re-checando symlinks (itens novos do kit)..."
# Repassa as MESMAS flags que você usaria no install; sem --force para não
# sobrescrever os arquivos por-projeto (CLAUDE.md etc.).
bash "$SCRIPT_DIR/install.sh" --target "$SUPER" "$@"

cat <<EOF

✅ Kit atualizado.
   Não esqueça de registrar o novo ponteiro do submódulo:
     git -C "$SUPER" add "$SUB_REL"
     git -C "$SUPER" commit -m "chore: bump engineering-kit"
EOF
