#!/usr/bin/env fish
set -gx NVM_DIR "$HOME/.nvm"
if test -s "$NVM_DIR/nvm.sh"
  source "$NVM_DIR/nvm.sh"
end
npm install -g pnpm
