#!/usr/bin/env bash
# Run JaCoCo and enforce >= 90%. Reports divergence when configured below 90%.
# Warns (no fail) when JaCoCo is not configured.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

MIN=90
report_csv() { find "$REPO_ROOT" -path '*/jacoco*.csv' -o -path '*/jacoco/*.csv' 2>/dev/null | head -1; }

print_coverage_from_csv() {
  local csv="$1"
  awk -F, 'NR>1 {im+=$4; ic+=$5; bm+=$6; bc+=$7} END {
    if (ic+im>0) printf "line=%.1f%% ", 100*ic/(ic+im);
    if (bc+bm>0) printf "branch=%.1f%%", 100*bc/(bc+bm);
    print ""
  }' "$csv"
}

case "$BUILD_TOOL" in
  maven)
    if maven_has 'jacoco-maven-plugin'; then
      run_build -q verify
      csv="$(report_csv || true)"
      [ -n "$csv" ] && { info "Cobertura: $(print_coverage_from_csv "$csv")"; }
      ok "JaCoCo executado (threshold do pom aplicado via jacoco:check)."
      grep -qE '<minimum>0\.9|0\.90' "$BUILD_FILE" 2>/dev/null || warn "Confirme que o threshold no pom é >= ${MIN}% (line+branch)."
    else
      warn "jacoco-maven-plugin ausente. Veja .ai/rules/jacoco-coverage.md para habilitar (meta ${MIN}%)."
    fi ;;
  gradle)
    if gradle_has 'jacoco'; then
      run_build jacocoTestReport jacocoTestCoverageVerification
      ok "JaCoCo (Gradle) executado."
    else warn "Plugin jacoco ausente no Gradle. Meta ${MIN}%. Veja .ai/rules/jacoco-coverage.md."; fi ;;
  *) warn "Build tool não detectado." ;;
esac
