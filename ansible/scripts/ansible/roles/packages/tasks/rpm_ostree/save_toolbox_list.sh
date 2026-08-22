#!/usr/bin/env bash
set -euo pipefail
podman ps -a --filter label=com.github.containers.toolbox=true --format '{{.Names}}' 2>/dev/null | sort | tr '\n' ' '
