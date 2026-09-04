#!/usr/bin/env bash
set -euo pipefail

OVERRIDES=(
  --nosocket=fallback-x11
  --socket=wayland
  --socket=x11
  --env=ELECTRON_OZONE_PLATFORM_HINT=x11
  --filesystem=xdg-cache:create
  --filesystem=xdg-config:create
)

flatpak list --app --columns=application 2>/dev/null | while read -r app; do
  if flatpak info --show-metadata "$app" 2>/dev/null | grep -q "org.electronjs.Electron2.BaseApp"; then
    flatpak override --user --reset "$app" 2>/dev/null || true
    flatpak override --user "${OVERRIDES[@]}" "$app"
  fi
done
