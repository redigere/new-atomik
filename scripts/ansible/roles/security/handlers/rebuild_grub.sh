#!/usr/bin/env bash
set -euo pipefail
if command -v grub2-mkconfig &>/dev/null; then
  grub2-mkconfig -o /boot/grub2/grub.cfg
elif command -v grub-mkconfig &>/dev/null; then
  grub-mkconfig -o /boot/grub/grub.cfg
else
  echo "No grub-mkconfig found"
fi
