#!/usr/bin/env bash
set -euo pipefail

export FASTMCP_LOG_LEVEL="${FASTMCP_LOG_LEVEL:-ERROR}"

exec uvx awslabs.aws-documentation-mcp-server@latest "$@"
