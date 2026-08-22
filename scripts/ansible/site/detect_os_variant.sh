#!/usr/bin/env bash
set -euo pipefail
refspec=$(rpm-ostree status 2>/dev/null | head -20 | grep -oP 'fedora:[^ ]+' | head -1 || echo "")
if echo "$refspec" | grep -q "silverblue"; then
  echo "silverblue"
elif echo "$refspec" | grep -q "kinoite"; then
  echo "kinoite"
elif echo "$refspec" | grep -q "cosmic-atomic"; then
  echo "cosmic-atomic"
else
  echo "silverblue"
fi
