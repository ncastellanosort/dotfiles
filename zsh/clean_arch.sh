#!/bin/bash
set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

before_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)

# Mantiene solo los últimos 3 paquetes
paccache -ruk3 || true

# Limpia descargas incompletas de pacman
rm -rf /var/cache/pacman/pkg/download-* || true

# Limpieza AUR (si existe yay)
if command -v yay &>/dev/null; then
  yay -Sc --noconfirm || true
fi

# NO tocar /tmp
rm -rf /var/tmp/* || true

# Limpiar journals
journalctl --vacuum-time=7d >/dev/null || true

# Cache de thumbnails del usuario sudo
if [[ -n "${SUDO_USER:-}" ]]; then
  user_home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
  rm -rf "$user_home/.cache/thumbnails/"* 2>/dev/null || true
fi

after_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)

echo "Pacman cache before: $before_cache"
echo "Pacman cache after:  $after_cache"
echo "Cleanup complete."

