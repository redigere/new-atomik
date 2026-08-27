#!/usr/bin/env fish

mkdir -p ~/.config/cosmic

# Disable animations for better performance
if not test -f ~/.config/cosmic/.no-animations
    touch ~/.config/cosmic/.no-animations
end

# Disable screen blanking via dconf (COSMIC reads this for fallback)
set -l SCHEMA "org.gnome.desktop.session"
dconf write /org/gnome/desktop/session/idle-delay "uint32 0" 2>/dev/null
dconf write /org/gnome/desktop/screensaver lock-enabled "false" 2>/dev/null
dconf write /org/gnome/desktop/screensaver idle-activation-enabled "false" 2>/dev/null

# Disable power management suspend
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null
