#!/usr/bin/env fish
set SPOTIFY "com.spotify.Client"

if not flatpak list --app 2>/dev/null | string match -q -- "*$SPOTIFY*"
  echo "Spotify ($SPOTIFY) not installed; skipping SpotX"
  exit 0
end

fish <(curl -sSL https://spotx-official.github.io/run.sh)
