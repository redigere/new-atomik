#!/usr/bin/env bash
set -euo pipefail
systemctl --user --machine="$ATOMIK_USER"@.host mask plasma-kaccess.service
systemctl --user --machine="$ATOMIK_USER"@.host mask plasma-xembedsniproxy.service
systemctl --user --machine="$ATOMIK_USER"@.host mask plasma-gmenudbusmenuproxy.service
