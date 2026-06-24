#!/usr/bin/env bash
# Run BDD tests when configured (Cucumber/JBehave/Spock). Warn when absent.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

HAS_FEATURES="$([ -d src/test/resources/features ] && echo true || echo false)"
HAS_BDD_DEP="$(maven_has 'cucumber|jbehave' || gradle_has 'cucumber|jbehave|spock' && echo true || echo false)"

if [ "$HAS_BDD_DEP" = "true" ]; then
  case "$BUILD_TOOL" in
    maven)  run_build -q test -Dtest='*Cucumber*,*BddTest,*RunCucumberTest' || run_build -q test; ok "BDD (Maven) executado" ;;
    gradle) run_build test --tests '*Cucumber*' || run_build test; ok "BDD (Gradle) executado" ;;
    *) warn "Build tool não detectado." ;;
  esac
elif [ "$HAS_FEATURES" = "true" ]; then
  warn "Há src/test/resources/features mas nenhuma dependência BDD configurada no build."
  warn "Veja .ai/rules/bdd.md para habilitar Cucumber/JBehave/Spock (sem quebrar o build)."
else
  warn "BDD não configurado e sem features/ — nada a rodar (não é falha)."
fi
