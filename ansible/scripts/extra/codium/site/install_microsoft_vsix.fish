#!/usr/bin/env fish
set -gx ELECTRON_RUN_AS_NODE 1
set item "$argv[1]"
set publisher (string replace -r '\..*' '' "$item")
set name (string replace -r '^[^.]*\.' '' "$item")
set name (string replace -r '\.' '_' "$name")
set url "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/latest/vspackage"
curl -fsSL "$url" -o /tmp/ext.vsix
set file_type (file -b /tmp/ext.vsix | head -1)
if echo "$file_type" | grep -qi gzip
  mv /tmp/ext.vsix /tmp/ext.vsix.gz
  gunzip -f /tmp/ext.vsix.gz
end
"$CODIUM_INSTALL_DIR/codium" "$CODIUM_INSTALL_DIR/resources/app/out/cli.js" --install-extension /tmp/ext.vsix 2>&1 | tail -1
rm -f /tmp/ext.vsix /tmp/ext.vsix.gz
