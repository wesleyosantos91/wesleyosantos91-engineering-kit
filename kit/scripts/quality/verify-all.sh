#!/usr/bin/env bash
# Orchestrate the quality gates. Flags:
#   --fast           format-check, checkstyle, unit, package-rules
#   --full           all gates (default)
#   --no-mutation    skip PIT
#   --no-integration skip integration tests
#   --no-bdd         skip BDD
#   --skip-coverage  skip JaCoCo
# Never runs destructive commands. Reports absent gates instead of failing unfairly.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
Q="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODE="full"
DO_MUTATION=1; DO_INTEGRATION=1; DO_BDD=1; DO_COVERAGE=1
for arg in "$@"; do
  case "$arg" in
    --fast) MODE="fast" ;;
    --full) MODE="full" ;;
    --no-mutation) DO_MUTATION=0 ;;
    --no-integration) DO_INTEGRATION=0 ;;
    --no-bdd) DO_BDD=0 ;;
    --skip-coverage) DO_COVERAGE=0 ;;
    *) warn "flag desconhecida ignorada: $arg" ;;
  esac
done

FAILED=()
run_gate() { # run_gate <label> <script...>
  local label="$1"; shift
  section "GATE: $label"
  if "$@"; then ok "$label ✔"; else err "$label ✘"; FAILED+=("$label"); fi
}

info "Modo: $MODE"

if [ "$MODE" = "fast" ]; then
  run_gate "format-check" bash "$Q/format-check.sh"
  run_gate "checkstyle"   bash "$Q/checkstyle.sh"
  run_gate "unit tests"   bash "$Q/test-unit.sh"
  run_gate "package-rules" bash "$Q/package-rules.sh"
else
  run_gate "format-check" bash "$Q/format-check.sh"
  run_gate "checkstyle"   bash "$Q/checkstyle.sh"
  run_gate "unit tests"   bash "$Q/test-unit.sh"
  [ "$DO_INTEGRATION" -eq 1 ] && run_gate "integration tests" bash "$Q/test-integration.sh" || warn "integration: pulado (--no-integration)"
  [ "$DO_BDD" -eq 1 ]         && run_gate "bdd tests"         bash "$Q/test-bdd.sh"         || warn "bdd: pulado (--no-bdd)"
  [ "$DO_COVERAGE" -eq 1 ]    && run_gate "jacoco >=90%"      bash "$Q/jacoco.sh"           || warn "coverage: pulado (--skip-coverage)"
  [ "$DO_MUTATION" -eq 1 ]    && run_gate "pit >=90%"         bash "$Q/mutation-test.sh"    || warn "mutation: pulado (--no-mutation)"
  run_gate "archunit"      bash "$Q/archunit.sh"
  # build/package (non-destructive)
  detect_build_tool
  case "$BUILD_TOOL" in
    maven)  run_gate "package" run_build -q -DskipTests package ;;
    gradle) run_gate "assemble" run_build assemble ;;
  esac
fi

# Always refresh the summary.
bash "$Q/quality-summary.sh" >/dev/null || true

section "Resultado"
if [ "${#FAILED[@]}" -eq 0 ]; then
  ok "Todos os gates executados passaram (modo $MODE)."
  info "Resumo: .ai/reports/quality-summary.md"
  exit 0
else
  err "Gates com falha: ${FAILED[*]}"
  info "Resumo: .ai/reports/quality-summary.md"
  exit 1
fi
