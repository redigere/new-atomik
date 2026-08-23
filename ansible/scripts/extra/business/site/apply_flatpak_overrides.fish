#!/usr/bin/env fish
set FLATPAK_ID $argv[1]
set OVERRIDE_CMD "flatpak override --user"
for pair in $OVERRIDE_ENVS
  set OVERRIDE_CMD "$OVERRIDE_CMD --env=$pair"
end
for fs in $OVERRIDE_FILESYSTEMS
  set OVERRIDE_CMD "$OVERRIDE_CMD --filesystem=$fs"
end
eval $OVERRIDE_CMD $FLATPAK_ID
