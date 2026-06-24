#!/usr/bin/env bash
# ============================================================================
# wesleyosantos91-engineering-kit — install
#
# Aplica o kit (skills, agents, commands, devcontainer, scripts, quality gates,
# MCPs) num repositório ALVO usando SYMLINKS para o payload do submódulo.
#
# Princípio "fonte única":
#   - Tudo que NÃO tem placeholder vira SYMLINK -> bebe direto do submódulo.
#     `git submodule update --remote` muda o conteúdo apontado sem recopiar.
#   - Arquivos COM placeholder (__BASE_PACKAGE__ / __PROJECT_NAME__) são
#     COPIADOS e substituídos (scaffold por-projeto, editável à vontade).
#
# Idempotente; por padrão NÃO sobrescreve o que já existe (use --force).
# ============================================================================
set -euo pipefail

# No Git Bash/MSYS (Windows), 'ln -s' por padrão COPIA em vez de criar symlink —
# isso quebraria a "fonte única". Forçamos symlink nativo (exige Developer Mode).
# Em Linux/macOS (e no DevContainer) isso é inócuo.
export MSYS=winsymlinks:nativestrict

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAYLOAD="$SCRIPT_DIR/kit"

FORCE=0
BASE_PACKAGE=""
PROJECT_NAME=""
TARGET=""

usage() {
  cat <<EOF
Uso: install.sh [opções]

Cria symlinks do kit (e faz scaffold dos arquivos com placeholder) no projeto alvo.
Por padrão o alvo é o superprojeto que contém este submódulo.

Opções:
  --target <dir>         Diretório alvo (default: superprojeto do submódulo / cwd)
  --base-package <pkg>   Base package Java p/ scaffold (default: com.example)
  --name <nome>          Nome do projeto p/ scaffold (default: nome da pasta alvo)
  --force                Sobrescreve symlinks/arquivos já existentes no alvo
  -h, --help             Mostra esta ajuda

Exemplos:
  bash .engineering-kit/install.sh
  bash .engineering-kit/install.sh --base-package com.acme.orders --name orders
  bash .engineering-kit/install.sh --force --target /caminho/do/projeto
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target)       TARGET="${2:-}"; shift 2 ;;
    --base-package) BASE_PACKAGE="${2:-}"; shift 2 ;;
    --name)         PROJECT_NAME="${2:-}"; shift 2 ;;
    --force)        FORCE=1; shift ;;
    -h|--help)      usage; exit 0 ;;
    -*)             echo "Opção desconhecida: $1" >&2; usage; exit 2 ;;
    *)              echo "Argumento inesperado: $1" >&2; usage; exit 2 ;;
  esac
done

[ -d "$PAYLOAD" ] || { echo "ERRO: payload não encontrado em $PAYLOAD" >&2; exit 1; }

# --- Descobre o alvo --------------------------------------------------------
if [ -z "$TARGET" ]; then
  # 1) superprojeto que contém este submódulo (caso ideal)
  TARGET="$(git -C "$SCRIPT_DIR" rev-parse --show-superproject-working-tree 2>/dev/null || true)"
  # 2) pasta-pai do repo do kit (submódulo adicionado em <projeto>/.engineering-kit)
  [ -z "$TARGET" ] && TARGET="$(dirname "$SCRIPT_DIR")"
fi
mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

PROJECT_NAME="${PROJECT_NAME:-$(basename "$TARGET")}"

# Auto-detecta o base package a partir do código do projeto (declaração `package`
# do 1º .java em src/main/java). Permite o postCreate do devcontainer rodar sem args.
detect_base_package() {
  local t="$1" f pkg
  f="$(find "$t/src/main/java" -name '*.java' 2>/dev/null | head -1)"
  [ -n "$f" ] && pkg="$(grep -m1 '^package ' "$f" 2>/dev/null | sed 's/^package //; s/;.*//' | tr -d ' \r')"
  echo "${pkg:-com.example}"
}
if [ -z "$BASE_PACKAGE" ]; then BASE_PACKAGE="$(detect_base_package "$TARGET")"; fi

if [ "$TARGET" = "$SCRIPT_DIR" ]; then
  echo "ERRO: alvo == diretório do kit. Rode a partir do projeto que usa o submódulo," >&2
  echo "      ou passe --target apontando para o projeto." >&2
  exit 1
fi

echo "Kit:           $SCRIPT_DIR"
echo "Alvo:          $TARGET"
echo "Projeto:       $PROJECT_NAME"
echo "Base package:  $BASE_PACKAGE"
echo "Sobrescrever:  $([ "$FORCE" -eq 1 ] && echo sim || echo não)"
echo

LINKS=0; COPIES=0; SKIPS=0

# Caminho relativo de $1 visto a partir do diretório $2.
relpath() { realpath -m --relative-to="$2" "$1"; }

# Há algum arquivo com placeholder em $1 (arquivo ou dir, recursivo)?
has_placeholder() {
  local p="$1"
  if [ -f "$p" ]; then
    grep -qI -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' "$p" 2>/dev/null
  else
    grep -rqI -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' "$p" 2>/dev/null
  fi
}

make_symlink() {
  local src="$1" dst="$2" rel
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$FORCE" -eq 1 ]; then rm -rf "$dst"; else
      echo "  skip (existe): ${dst#$TARGET/}"; SKIPS=$((SKIPS+1)); return; fi
  fi
  mkdir -p "$(dirname "$dst")"
  rel="$(relpath "$src" "$(dirname "$dst")")"
  ln -s "$rel" "$dst"
  if [ ! -L "$dst" ]; then
    echo "ERRO: '$dst' não virou symlink (provável cópia do Git Bash sem Developer Mode)." >&2
    echo "      Ative o Developer Mode do Windows ou rode o install DENTRO do DevContainer." >&2
    echo "      Detalhes: docs/windows.md" >&2
    exit 1
  fi
  echo "  symlink: ${dst#$TARGET/} -> $rel"; LINKS=$((LINKS+1))
}

copy_subst() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
    echo "  skip (existe): ${dst#$TARGET/}"; SKIPS=$((SKIPS+1)); return; fi
  mkdir -p "$(dirname "$dst")"
  sed "s/__BASE_PACKAGE__/${BASE_PACKAGE//\//\\/}/g; s/__PROJECT_NAME__/${PROJECT_NAME//\//\\/}/g" "$src" > "$dst"
  echo "  copy+subst: ${dst#$TARGET/}"; COPIES=$((COPIES+1))
}

# Decide, por item, entre symlink (estável) e copy+subst (placeholder).
process() {
  local src="$1" dst="$2"
  if [ -d "$src" ]; then
    if has_placeholder "$src"; then
      # dir misto: recria a árvore e decide por filho
      mkdir -p "$dst"
      local child base
      while IFS= read -r -d '' child; do
        base="$(basename "$child")"
        process "$child" "$dst/$base"
      done < <(find "$src" -mindepth 1 -maxdepth 1 -print0)
    else
      make_symlink "$src" "$dst"   # dir 100% estável: 1 symlink só
    fi
  else
    if has_placeholder "$src"; then copy_subst "$src" "$dst"; else make_symlink "$src" "$dst"; fi
  fi
}

echo "[1/3] Aplicando configs (symlink p/ estável, copy+subst p/ placeholder)..."
while IFS= read -r -d '' entry; do
  base="$(basename "$entry")"
  [ "$base" = "gitignore.kit" ] && continue   # tratado no passo do .gitignore
  process "$entry" "$TARGET/$base"
done < <(find "$PAYLOAD" -mindepth 1 -maxdepth 1 -print0)

echo "[2/3] Garantindo bit de execução nos scripts .sh..."
[ -d "$PAYLOAD/scripts" ] && find "$PAYLOAD/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
[ -f "$PAYLOAD/.devcontainer/install-tools.sh" ] && chmod +x "$PAYLOAD/.devcontainer/install-tools.sh" 2>/dev/null || true

echo "[3/3] Aplicando bloco do kit no .gitignore do alvo..."
MARK_BEGIN="# >>> engineering-kit (managed) >>>"
MARK_END="# <<< engineering-kit (managed) <<<"
GI="$TARGET/.gitignore"
if [ ! -f "$GI" ]; then
  { echo "$MARK_BEGIN"; cat "$PAYLOAD/gitignore.kit"; echo "$MARK_END"; } > "$GI"
  echo "  .gitignore criado a partir do kit."
elif ! grep -qF "$MARK_BEGIN" "$GI"; then
  { echo ""; echo "$MARK_BEGIN"; cat "$PAYLOAD/gitignore.kit"; echo "$MARK_END"; } >> "$GI"
  echo "  bloco do kit anexado ao .gitignore existente."
else
  echo "  .gitignore já contém o bloco do kit (sem mudança)."
fi

cat <<EOF

✅ Kit aplicado em: $TARGET
   symlinks: $LINKS · copiados+subst: $COPIES · pulados: $SKIPS

Próximos passos:
  1. Abra no DevContainer (VS Code: "Reopen in Container"). O install-tools.sh
     instala Claude Code, Codex, RTK, OpenSpec, Repomix, uv e registra os MCPs.
  2. Claude Code: na 1ª vez, aprove os MCPs do projeto (.mcp.json).
  3. Secrets: 'cp .env.example .env' e preencha (NUNCA commite o .env).
  4. Ajuste CLAUDE.md / AGENTS.md / .ai/harness.yaml (foram copiados; base=$BASE_PACKAGE).

Atualizar o kit depois:  bash $(relpath "$SCRIPT_DIR" "$TARGET")/update.sh
EOF
