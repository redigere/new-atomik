#!/usr/bin/env bash
set -euo pipefail
udevadm control --reload-rules && udevadm trigger
