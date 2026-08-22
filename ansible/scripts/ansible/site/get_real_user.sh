#!/usr/bin/env bash
set -euo pipefail
if [ -n "${SUDO_USER:-}" ]; then
  echo "${SUDO_USER:-}"
elif [ -n "${PKEXEC_UID:-}" ]; then
  getent passwd "${PKEXEC_UID:-}" | cut -d: -f1
else
  echo "${USER:-root}"
fi
