#!/usr/bin/env bash
# Shared helpers for the AI harness scripts.
# Source this file; it is idempotent and never runs destructive commands.
set -euo pipefail

# --- repo root -------------------------------------------------------------
# Resolve repo root from this file location (scripts/lib/common.sh).
HARNESS_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HARNESS_LIB_DIR/../.." && pwd)"
export REPO_ROOT
cd "$REPO_ROOT"

# --- logging ---------------------------------------------------------------
_c_reset=$'\033[0m'; _c_blue=$'\033[34m'; _c_yellow=$'\033[33m'; _c_red=$'\033[31m'; _c_green=$'\033[32m'
info()  { printf '%s[info]%s %s\n'  "$_c_blue"   "$_c_reset" "$*"; }
warn()  { printf '%s[warn]%s %s\n'  "$_c_yellow" "$_c_reset" "$*" >&2; }
err()   { printf '%s[err ]%s %s\n'  "$_c_red"    "$_c_reset" "$*" >&2; }
ok()    { printf '%s[ ok ]%s %s\n'  "$_c_green"  "$_c_reset" "$*"; }
section(){ printf '\n=== %s ===\n' "$*"; }

# --- build tool detection --------------------------------------------------
# Sets: BUILD_TOOL (maven|gradle|none), BUILD_CMD (runner), BUILD_FILE.
detect_build_tool() {
  if [ -f "$REPO_ROOT/pom.xml" ]; then
    BUILD_TOOL="maven"
    BUILD_FILE="$REPO_ROOT/pom.xml"
    if [ -x "$REPO_ROOT/mvnw" ]; then BUILD_CMD="./mvnw"; else BUILD_CMD="$(command -v mvn || echo mvn)"; fi
  elif [ -f "$REPO_ROOT/build.gradle" ] || [ -f "$REPO_ROOT/build.gradle.kts" ]; then
    BUILD_TOOL="gradle"
    BUILD_FILE="$([ -f "$REPO_ROOT/build.gradle" ] && echo "$REPO_ROOT/build.gradle" || echo "$REPO_ROOT/build.gradle.kts")"
    if [ -x "$REPO_ROOT/gradlew" ]; then BUILD_CMD="./gradlew"; else BUILD_CMD="$(command -v gradle || echo gradle)"; fi
  else
    BUILD_TOOL="none"; BUILD_FILE=""; BUILD_CMD=""
  fi
  export BUILD_TOOL BUILD_CMD BUILD_FILE
}

# --- maven/gradle plugin presence (best-effort, no execution) --------------
# maven_has <regex>  -> grep the pom for a plugin/dependency marker.
maven_has() { [ "${BUILD_TOOL:-}" = "maven" ] && grep -qiE "$1" "$BUILD_FILE" 2>/dev/null; }
# gradle_has <regex> -> grep gradle build files.
gradle_has() { [ "${BUILD_TOOL:-}" = "gradle" ] && grep -qiE "$1" "$BUILD_FILE" "$REPO_ROOT"/build.gradle* "$REPO_ROOT"/settings.gradle* 2>/dev/null; }

# --- java / framework / base package ---------------------------------------
detect_java_version() {
  JAVA_VERSION_CONFIGURED="unknown"
  if [ "${BUILD_TOOL:-}" = "maven" ]; then
    JAVA_VERSION_CONFIGURED="$(grep -oiE '<java.version>[^<]+' "$BUILD_FILE" 2>/dev/null | head -1 | sed -E 's/.*>//' || true)"
    [ -n "$JAVA_VERSION_CONFIGURED" ] || JAVA_VERSION_CONFIGURED="$(grep -oiE '<maven.compiler.release>[^<]+' "$BUILD_FILE" 2>/dev/null | head -1 | sed -E 's/.*>//' || true)"
  elif [ "${BUILD_TOOL:-}" = "gradle" ]; then
    JAVA_VERSION_CONFIGURED="$(grep -oiE '(languageVersion|sourceCompatibility|targetCompatibility)[^0-9]*[0-9]+' "$BUILD_FILE" "$REPO_ROOT"/build.gradle* 2>/dev/null | grep -oE '[0-9]+' | head -1 || true)"
  fi
  [ -n "${JAVA_VERSION_CONFIGURED:-}" ] || JAVA_VERSION_CONFIGURED="unknown"
  export JAVA_VERSION_CONFIGURED
}

detect_framework() {
  FRAMEWORK="plain-java"
  if [ -n "${BUILD_FILE:-}" ]; then
    if grep -qiE 'org.springframework.boot' "$BUILD_FILE" 2>/dev/null; then FRAMEWORK="spring-boot"
    elif grep -qiE 'io.quarkus' "$BUILD_FILE" 2>/dev/null; then FRAMEWORK="quarkus"
    elif grep -qiE 'io.micronaut' "$BUILD_FILE" 2>/dev/null; then FRAMEWORK="micronaut"
    fi
  fi
  export FRAMEWORK
}

detect_base_package() {
  BASE_PACKAGE="unknown"
  local app
  app="$(find "$REPO_ROOT/src/main/java" -type f -name '*.java' 2>/dev/null \
        | xargs grep -lE '^\s*public\s+(final\s+)?class .*\{?$' 2>/dev/null | head -1 || true)"
  [ -n "$app" ] || app="$(find "$REPO_ROOT/src/main/java" -type f -name '*.java' 2>/dev/null | head -1 || true)"
  if [ -n "$app" ]; then
    BASE_PACKAGE="$(grep -oE '^package\s+[a-zA-Z0-9_.]+' "$app" 2>/dev/null | head -1 | awk '{print $2}' || true)"
  fi
  [ -n "${BASE_PACKAGE:-}" ] || BASE_PACKAGE="unknown"
  export BASE_PACKAGE
}

# --- misc ------------------------------------------------------------------
now_utc() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }
git_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "n/a"; }
git_commit() { git rev-parse --short HEAD 2>/dev/null || echo "n/a"; }
is_git_repo() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }

# Run a build command, echoing it first. Never use destructive goals here.
run_build() {
  [ "${BUILD_TOOL:-}" != "none" ] || { warn "Nenhum build tool detectado; pulando: $*"; return 0; }
  info "exec: $BUILD_CMD $*"
  "$BUILD_CMD" "$@"
}
