#!/usr/bin/env bash
# Run PIT mutation testing and check mutation score >= 90% when configured.
# Warns (no fail) when PIT is not configured, or when there is no business code
# to mutate yet ("No mutations found").
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

MIN="${mutation_threshold:-90}"

mutation_score_from_report() {
  local xml; xml="$(find "$REPO_ROOT" -path '*/pit-reports/*mutations.xml' -o -name 'mutations.xml' 2>/dev/null | head -1 || true)"
  [ -n "$xml" ] || return 1
  local total killed
  total="$(grep -oc '<mutation ' "$xml" 2>/dev/null || echo 0)"
  killed="$(grep -oE 'status="KILLED"' "$xml" 2>/dev/null | wc -l | tr -d ' ')"
  [ "$total" -gt 0 ] 2>/dev/null || return 1
  awk -v k="$killed" -v t="$total" 'BEGIN { printf "%.1f", 100*k/t }'
}

run_pit() {
  case "$BUILD_TOOL" in
    maven)  "$BUILD_CMD" -q org.pitest:pitest-maven:mutationCoverage 2>&1 ;;
    gradle) "$BUILD_CMD" pitest 2>&1 ;;
  esac
}

case "$BUILD_TOOL" in
  maven|gradle)
    if [ "$BUILD_TOOL" = "maven" ] && ! maven_has 'pitest'; then
      warn "PIT ausente no pom.xml. Veja .ai/rules/pit-mutation-testing.md (meta ${MIN}%)."; exit 0
    fi
    if [ "$BUILD_TOOL" = "gradle" ] && ! gradle_has 'pitest'; then
      warn "Plugin pitest ausente no Gradle. Veja .ai/rules/pit-mutation-testing.md."; exit 0
    fi

    info "exec: PIT mutationCoverage (meta ${MIN}%)"
    set +e
    out="$(run_pit)"; rc=$?
    set -e

    if [ "$rc" -ne 0 ]; then
      if echo "$out" | grep -qiE "No mutations found"; then
        warn "PIT: nenhuma classe mutável ainda (sem código de negócio em domain/application)."
        warn "Gate de mutação será aplicado quando houver classes para mutar. Não é falha."
        exit 0
      fi
      echo "$out" | tail -25
      err "PIT falhou (ver acima)."
      exit 1
    fi

    score="$(mutation_score_from_report || true)"
    if [ -n "$score" ]; then
      info "Mutation score: ${score}%"
      awk -v s="$score" -v m="$MIN" 'BEGIN { exit (s+0 >= m) ? 0 : 1 }' \
        && ok "Mutation score >= ${MIN}%" \
        || { err "Mutation score ${score}% < ${MIN}% — mate os mutantes sobreviventes (ver pit-reports)."; exit 1; }
    else
      warn "PIT executou, mas não consegui ler o score (verifique pit-reports)."
    fi ;;
  *) warn "Build tool não detectado." ;;
esac
