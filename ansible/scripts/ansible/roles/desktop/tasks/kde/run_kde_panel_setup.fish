#!/usr/bin/env fish
systemctl --user stop plasma-plasmashell 2>/dev/null; or true
killall -9 plasmashell 2>/dev/null; or true
sleep 1
python3 /tmp/kde_panels.py
systemctl --user start plasma-plasmashell
