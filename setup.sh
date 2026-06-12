#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
PACKAGES=(nvim tmux kitty hypr waybar wofi zsh)
ROOT_PACKAGES=(greetd)  # target / (system configs), require sudo

# ── Prerequisites ──────────────────────────────────────────────
command -v git >/dev/null 2>&1  || { echo "ERROR: git is required. Install it first."; exit 1; }
command -v stow >/dev/null 2>&1 || { echo "ERROR: GNU Stow is required. Install it first."; exit 1; }

# ── Clone if needed ────────────────────────────────────────────
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles into $DOTFILES_DIR ..."
    git clone https://github.com/ncastellanosort/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# ── Stow each package ──────────────────────────────────────────
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ] || [ -f "$pkg" ]; then
        echo "Stowing $pkg ..."
        stow -v "$pkg"
    else
        echo "Skipping $pkg (not found in repo)"
    fi
done

# ── Stow system-level packages (target /) ─────────────────────
for pkg in "${ROOT_PACKAGES[@]}"; do
    if [ -d "$pkg" ] || [ -f "$pkg" ]; then
        echo "Stowing $pkg (system) ..."
        sudo stow -v --target=/ "$pkg"
    else
        echo "Skipping $pkg (not found in repo)"
    fi
done

echo ""
echo "Done. All dotfiles are now linked into \$HOME and /."
