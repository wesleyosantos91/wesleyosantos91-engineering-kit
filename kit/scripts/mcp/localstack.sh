#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${LOCALSTACK_AUTH_TOKEN:-}" ]]; then
  printf 'LOCALSTACK_AUTH_TOKEN is required. Export it locally; never commit it.\n' >&2
  exit 2
fi

export MCP_ANALYTICS_DISABLED="${MCP_ANALYTICS_DISABLED:-1}"
export MAIN_CONTAINER_NAME="${MAIN_CONTAINER_NAME:-localstack-main}"

exec npx -y @localstack/localstack-mcp-server@0.5.0 "$@"
