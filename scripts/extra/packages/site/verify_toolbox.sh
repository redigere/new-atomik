#!/usr/bin/env bash
set -euo pipefail
SAVED="$TOOLBOX_BEFORE"
[ -z "$SAVED" ] && echo "no_toolbox_containers" && exit 0
CURRENT=$(podman ps -a --filter label=com.github.containers.toolbox=true --format '{{.Names}}' 2>/dev/null | sort | tr '\n' ' ')
for name in $SAVED; do
  FOUND=0
  for cname in $CURRENT; do
    [ "$name" = "$cname" ] && FOUND=1 && break
  done
  [ "$FOUND" = 0 ] && echo "MISSING: $name"
done
