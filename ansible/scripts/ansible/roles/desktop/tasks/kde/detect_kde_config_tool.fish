#!/usr/bin/env fish
if command -q kwriteconfig6
  echo "kwriteconfig6"
else if command -q kwriteconfig5
  echo "kwriteconfig5"
else
  echo "none"
end
