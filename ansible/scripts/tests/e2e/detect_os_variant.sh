#!/usr/bin/env bash
set -euo pipefail
refspec=$(ostree admin status 2>/dev/null | grep -oP 'ostree://\K[^: ]+' || echo "")
if echo "$refspec" | grep -q "silverblue"; then
  echo "silverblue"
elif echo "$refspec" | grep -q "kinoite"; then
  echo "kinoite"
elif echo "$refspec" | grep -q "cosmic-atomic"; then
  echo "cosmic-atomic"
else
  echo "silverblue"
fi
