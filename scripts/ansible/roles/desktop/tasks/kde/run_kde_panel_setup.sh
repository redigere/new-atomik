#!/usr/bin/env bash
set -euo pipefail
systemctl --user stop plasma-plasmashell 2>/dev/null || true
killall -9 plasmashell 2>/dev/null || true
sleep 1
python3 /tmp/kde_panels.py
systemctl --user start plasma-plasmashell
