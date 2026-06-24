#!/usr/bin/env bash
# Run ArchUnit tests when present; otherwise fall back to package-rules.sh.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

ARCH_TESTS="$(find src/test -type f \( -name '*ArchTest*.java' -o -name '*ArchitectureTest*.java' -o -name '*ArchUnit*.java' \) 2>/dev/null || true)"
HAS_DEP="$(maven_has 'archunit' || gradle_has 'archunit' && echo true || echo false)"

if [ -n "$ARCH_TESTS" ] && [ "$HAS_DEP" = "true" ]; then
  info "Executando testes ArchUnit"
  case "$BUILD_TOOL" in
    maven)  run_build -q test -Dtest='*ArchTest,*ArchitectureTest,*ArchUnit*' ;;
    gradle) run_build test --tests '*Arch*' ;;
  esac
  ok "ArchUnit OK"
else
  warn "ArchUnit não configurado (dep ou testes ausentes). Usando fallback package-rules.sh."
  warn "Para habilitar ArchUnit, veja config/archunit/architecture-rules.md e .ai/rules/archunit.md."
  exec "$(dirname "${BASH_SOURCE[0]}")/package-rules.sh"
fi
