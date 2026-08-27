#!/usr/bin/env fish
if not command -v flatpak >/dev/null 2>&1
    rpm-ostree install -y --idempotent --allow-inactive flatpak
end
