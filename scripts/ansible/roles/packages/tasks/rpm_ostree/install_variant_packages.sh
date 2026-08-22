#!/usr/bin/env bash
set -euo pipefail
rpm-ostree install -y --idempotent --allow-inactive $ATOMIK_VARIANT_PACKAGES
