#!/usr/bin/env bash
set -euo pipefail

exec docker run -i --rm \
  hashicorp/terraform-mcp-server:1.0.0 --toolsets=registry "$@"
