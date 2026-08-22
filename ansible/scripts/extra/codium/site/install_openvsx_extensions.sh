#!/usr/bin/env bash
set -euo pipefail
export ELECTRON_RUN_AS_NODE=1
"$CODIUM_INSTALL_DIR"/codium "$CODIUM_INSTALL_DIR/resources/app/out/cli.js" --install-extension "$1" 2>&1 | tail -1
