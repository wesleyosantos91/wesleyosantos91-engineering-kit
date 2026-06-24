#!/usr/bin/env bash
# Run unit tests. Maven: Surefire (test). Gradle: test.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

case "$BUILD_TOOL" in
  maven)  run_build -q test;  ok "Unit tests (Maven/Surefire) concluídos" ;;
  gradle) run_build test;     ok "Unit tests (Gradle) concluídos" ;;
  *) warn "Build tool não detectado; sem testes unitários para rodar." ;;
esac
