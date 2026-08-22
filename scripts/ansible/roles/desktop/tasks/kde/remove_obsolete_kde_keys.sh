#!/usr/bin/env bash
set -euo pipefail
"$KDE_CONFIG_TOOL" --file kwinrc --group kwin --key Opacity --delete
"$KDE_CONFIG_TOOL" --file kwinrc --group Blur --key Blur --delete
