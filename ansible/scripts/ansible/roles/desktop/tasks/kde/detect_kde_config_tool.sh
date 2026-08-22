#!/usr/bin/env bash
set -euo pipefail
if command -v kwriteconfig6 >/dev/null 2>&1; then
  echo "kwriteconfig6"
elif command -v kwriteconfig5 >/dev/null 2>&1; then
  echo "kwriteconfig5"
else
  echo "none"
fi
