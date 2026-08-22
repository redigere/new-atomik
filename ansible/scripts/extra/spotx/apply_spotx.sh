#!/usr/bin/env bash
set -euo pipefail

SPOTIFY="com.spotify.Client"

if ! flatpak list --app 2>/dev/null | grep -q "$SPOTIFY"; then
  echo "Spotify ($SPOTIFY) not installed; skipping SpotX"
  exit 0
fi

bash <(curl -sSL https://spotx-official.github.io/run.sh)
