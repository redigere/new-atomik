#!/usr/bin/env bash
set -euo pipefail
FLATPAK_ID="$1"
OVERRIDE_CMD="flatpak override --user"
for pair in $OVERRIDE_ENVS; do
  OVERRIDE_CMD="$OVERRIDE_CMD --env=$pair"
done
for fs in $OVERRIDE_FILESYSTEMS; do
  OVERRIDE_CMD="$OVERRIDE_CMD --filesystem=$fs"
done
$OVERRIDE_CMD "$FLATPAK_ID"
