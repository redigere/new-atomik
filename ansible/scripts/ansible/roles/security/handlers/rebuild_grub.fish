#!/usr/bin/env fish
if command -v grub2-mkconfig >/dev/null 2>&1
  grub2-mkconfig -o /boot/grub2/grub.cfg
else if command -v grub-mkconfig >/dev/null 2>&1
  grub-mkconfig -o /boot/grub/grub.cfg
else
  echo "No grub-mkconfig found"
end
