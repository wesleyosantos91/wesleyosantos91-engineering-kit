#!/usr/bin/env bash
# Run Checkstyle when configured. Fallback: validate the Java 25 config exists
# and warn that the plugin is missing (no unfair failure).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

CONFIG="$REPO_ROOT/config/checkstyle/checkstyle-java25.xml"

case "$BUILD_TOOL" in
  maven)
    if maven_has 'maven-checkstyle-plugin'; then run_build -q checkstyle:check; ok "Checkstyle OK"
    else
      warn "maven-checkstyle-plugin ausente no pom.xml."
      [ -f "$CONFIG" ] && info "Config pronta: config/checkstyle/checkstyle-java25.xml — veja .ai/rules/java-25-checkstyle.md para habilitar." || err "Config Checkstyle ausente!"
    fi ;;
  gradle)
    if gradle_has 'checkstyle'; then run_build checkstyleMain checkstyleTest; ok "Checkstyle OK"
    else warn "Plugin checkstyle ausente no Gradle. Config: config/checkstyle/checkstyle-java25.xml"; fi ;;
  *) warn "Build tool não detectado." ;;
esac
