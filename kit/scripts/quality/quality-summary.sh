#!/usr/bin/env bash
# Produce a consolidated quality summary. Read-only aggregation; never fails the
# build. Output: .ai/reports/quality-summary.md
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool; detect_java_version; detect_framework; detect_base_package

OUT="$REPO_ROOT/.ai/reports/quality-summary.md"
mkdir -p "$(dirname "$OUT")"

present() { if eval "$1"; then echo "configured"; else echo "ABSENT"; fi; }

CS="$(present 'maven_has maven-checkstyle-plugin || gradle_has checkstyle')"
SP="$(present 'maven_has spotless-maven-plugin || gradle_has spotless')"
JA="$(present 'maven_has jacoco-maven-plugin || gradle_has jacoco')"
PI="$(present 'maven_has pitest || gradle_has pitest')"
AU="$(present 'maven_has archunit || gradle_has archunit')"
IT="$([ -n "$(find src/test -type f \( -name "*IT.java" -o -name "*IntegrationTest.java" \) 2>/dev/null | head -1)" ] && echo "present" || echo "none")"
BDD="$([ -d src/test/resources/features ] || maven_has 'cucumber|jbehave' && echo "present" || echo "none")"

{
  echo "# Quality summary"
  echo
  echo "| campo | valor |"
  echo "|---|---|"
  echo "| date | $(now_utc) |"
  echo "| branch | $(git_branch) |"
  echo "| commit | $(git_commit) |"
  echo "| build tool | ${BUILD_TOOL} |"
  echo "| java | ${JAVA_VERSION_CONFIGURED} |"
  echo "| framework | ${FRAMEWORK} |"
  echo "| base package | ${BASE_PACKAGE} |"
  echo
  echo "## Gates (configuração)"
  echo
  echo "| gate | estado |"
  echo "|---|---|"
  echo "| Spotless (format) | ${SP} |"
  echo "| Checkstyle (Java 25) | ${CS} |"
  echo "| Unit tests | $([ -d src/test/java ] && echo present || echo none) |"
  echo "| Integration tests | ${IT} |"
  echo "| BDD | ${BDD} |"
  echo "| JaCoCo (>=90%) | ${JA} |"
  echo "| PIT mutation (>=90%) | ${PI} |"
  echo "| ArchUnit | ${AU} (fallback: package-rules.sh) |"
  echo
  echo "## Relatórios relacionados"
  echo "- openspec-check: $([ -f "$REPO_ROOT/.ai/reports/openspec-check.md" ] && echo "\`.ai/reports/openspec-check.md\`" || echo "não gerado")"
  echo "- context-pack: $([ -f "$REPO_ROOT/.ai/reports/context-pack.md" ] && echo "\`.ai/reports/context-pack.md\`" || echo "não gerado")"
  echo
  echo "## Próximos passos sugeridos"
  [ "$SP" = "ABSENT" ] && echo "- Habilitar Spotless (config/spotless/spotless-java25.md)"
  [ "$CS" = "ABSENT" ] && echo "- Habilitar Checkstyle (config/checkstyle/checkstyle-java25.xml + .ai/rules/java-25-checkstyle.md)"
  [ "$JA" = "ABSENT" ] && echo "- Habilitar JaCoCo com threshold 90% (.ai/rules/jacoco-coverage.md)"
  [ "$PI" = "ABSENT" ] && echo "- Habilitar PIT com score 90% (.ai/rules/pit-mutation-testing.md)"
  [ "$AU" = "ABSENT" ] && echo "- Habilitar ArchUnit (config/archunit/architecture-rules.md) — enquanto isso, package-rules.sh cobre o essencial"
  echo "- Plugins de build: ver \`config/pom-quality-plugins.example.xml\` (opt-in, não aplicado automaticamente)"
} > "$OUT"

cat "$OUT"
echo
ok "quality summary: ${OUT#"$REPO_ROOT/"}"
