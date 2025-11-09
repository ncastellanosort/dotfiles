#!/bin/bash

set -euo pipefail
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

before_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)

paccache -ruk3

if command -v yay &> /dev/null; then
  yay -Sc --noconfirm > /dev/null
fi

rm -rf /tmp/* /var/tmp/*

journalctl --vacuum-time=7d > /dev/null

if [[ ${SUDO_USER:-} ]]; then
  user_home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
  rm -rf "$user_home/.cache/thumbnails/"*
fi

after_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)

echo "Pacman cache before: $before_cache"
echo "Pacman cache after:  $after_cache"
echo "Cleanup complete."
