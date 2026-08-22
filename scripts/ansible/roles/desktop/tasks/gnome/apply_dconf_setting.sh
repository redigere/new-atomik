#!/usr/bin/env bash
set -euo pipefail
dconf write "$1" "$2"
