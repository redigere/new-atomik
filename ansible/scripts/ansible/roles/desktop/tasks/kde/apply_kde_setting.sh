#!/usr/bin/env bash
set -euo pipefail
"$KDE_CONFIG_TOOL" --file "$1" --group "$2" --key "$3" "$4"
