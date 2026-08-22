#!/usr/bin/env bash
set -euo pipefail
firewall-cmd --permanent --add-service "$1"
firewall-cmd --reload
