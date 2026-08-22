#!/usr/bin/env bash
set -euo pipefail
TARGET="$ATOMIK_RPM_REMOVE"
[ -z "$TARGET" ] && echo "none_to_remove" && exit 0
TO_REMOVE=""
for p in $TARGET; do
  if rpm -q --root / "$p" >/dev/null 2>&1; then
    TO_REMOVE="$TO_REMOVE $p"
  fi
done
[ -z "$TO_REMOVE" ] && echo "none_to_remove" && exit 0
if rpm-ostree override remove $TO_REMOVE; then
  echo "removed: $TO_REMOVE"
else
  for p in $TO_REMOVE; do
    rpm-ostree override remove "$p" 2>/dev/null && echo "removed: $p" || echo "skipped: $p"
  done
fi
