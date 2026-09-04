# Atomik

Atomik is an Ansible-based declarative configuration for Fedora Atomic desktops (Silverblue, Kinoite, Cosmic Atomic). It adapts to the detected desktop environment at runtime.

## Requirements

4 GB RAM minimum. The system must already be running Fedora Silverblue, Kinoite, or Cosmic Atomic.

## Usage

The following operations are available:

make apply applies the full configuration.
make apply-repos configures repositories.
make apply-packages installs and removes packages.
make apply-security applies security hardening.
make apply-desktop configures desktop settings.
make apply-extra-gnome applies GNOME settings.
make apply-extra-codium installs debloated VSCodium.
make apply-extra-devtools sets up development tools.
make apply-extra-flatpak installs Flatpak apps and fixes Electron overrides.
make apply-extra-gaming installs gaming Flatpaks.
make apply-extra-business installs business Flatpaks.

## Electron Flatpak Fix

All Electron-based Flatpak apps (Discord, Slack, Spotify, Signal, etc.) are affected by a sandbox regression in Flatpak 1.17.x where the fallback-x11 socket fails to forward $DISPLAY. Atomik detects every installed Electron app at runtime and applies the correct overrides: nosocket=fallback-x11, socket=wayland, socket=x11, and ELECTRON_OZONE_PLATFORM_HINT=x11. A systemd path unit monitors /var/lib/flatpak/app/ so overrides are reapplied automatically whenever a new app is installed.

## COSMIC Desktop

COSMIC receives special treatment to prevent glitches, freezes, and stuttering. GPU rendering is hardened with explicit Mesa, GL sync, and GBM environment variables. The AMDGPU driver is set to high performance mode on boot. The cosmic-comp compositor gets realtime CPU scheduling priority. xdg-desktop-portal is enabled for proper file chooser and screenshot support.

## Security

Firewalld, audit rules, hardened kernel parameters, SSH key-only auth, resource limits.

## Memory Management

ZRAM compressed swap, systemd-oomd with desktop-tuned thresholds, no earlyoom.

## Directory Layout

ansible contains the Ansible playbooks and roles.
extra contains optional ansible extras such as gnome, codium, devtools, flatpak, gaming and business.
extra/codium/site.yml installs and configures VSCodium.

## Reset

Revert the system to baseline: uninstall custom packages, remove repositories, delete wallpapers, reset desktop settings.
