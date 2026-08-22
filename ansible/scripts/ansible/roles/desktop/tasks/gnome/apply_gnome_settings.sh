#!/usr/bin/env bash
set -euo pipefail
gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Noto Sans Mono 11'
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Super>'
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
