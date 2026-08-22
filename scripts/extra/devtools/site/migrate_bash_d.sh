#!/usr/bin/env bash
set -euo pipefail
if [ -d "$BASH_D_LINK" ] && [ ! -L "$BASH_D_LINK" ]; then
  cp -rP "$BASH_D_LINK"/* "$BASH_D/" || true
  rm -rf "$BASH_D_LINK"
fi
