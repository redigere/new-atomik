#!/usr/bin/env bash
set -euo pipefail
rpm-ostree install -y --idempotent --allow-inactive $ATOMIK_RPM_INSTALL
