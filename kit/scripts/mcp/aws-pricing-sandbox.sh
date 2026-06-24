#!/usr/bin/env bash
set -euo pipefail

export AWS_PROFILE="${AWS_PROFILE:-sandbox}"
export AWS_REGION="${AWS_REGION:-us-east-1}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-$AWS_REGION}"
export FASTMCP_LOG_LEVEL="${FASTMCP_LOG_LEVEL:-ERROR}"

exec uvx awslabs.aws-pricing-mcp-server@latest "$@"
