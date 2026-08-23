#!/usr/bin/env fish
if test -d "$BASH_D_LINK"; and not test -L "$BASH_D_LINK"
  cp -rP "$BASH_D_LINK"/* "$BASH_D/"; or true
  rm -rf "$BASH_D_LINK"
end
