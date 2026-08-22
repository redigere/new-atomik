#!/usr/bin/env bash
set -euo pipefail
export ELECTRON_RUN_AS_NODE=1
item="$1"
publisher="${item%%.*}"
name="${item#*.}"
name="${name//./_}"
url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${publisher}/vsextensions/${name}/latest/vspackage"
curl -fsSL "$url" -o /tmp/ext.vsix
file_type=$(file -b /tmp/ext.vsix | head -1)
if echo "$file_type" | grep -qi gzip; then
  mv /tmp/ext.vsix /tmp/ext.vsix.gz && gunzip -f /tmp/ext.vsix.gz
fi
"$CODIUM_INSTALL_DIR"/codium "$CODIUM_INSTALL_DIR/resources/app/out/cli.js" --install-extension /tmp/ext.vsix 2>&1 | tail -1
rm -f /tmp/ext.vsix /tmp/ext.vsix.gz
