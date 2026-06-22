# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for an Arch Linux + Hyprland (Wayland) system, managed with **GNU Stow**. Each top-level directory is a "package" whose internal structure mirrors `$HOME`. Stow creates symlinks from the repo into `$HOME`.

## Common Commands

### Applying configs
```bash
cd ~/.dotfiles
stow <package>          # create symlinks for one package
stow -v <package>       # verbose: see each symlink
bash setup.sh           # stow all packages (nvim tmux ghostty hypr waybar wofi zsh)
```

### Removing configs
```bash
stow -D <package>       # remove symlinks for a package (does not delete repo files)
```

### Adding a new package
```bash
mkdir -p ~/.dotfiles/<name>/.config/<name>
# move existing config files into that directory
cd ~/.dotfiles && stow <name>
```

### One-time: adopt existing config into the repo
```bash
stow --adopt <package>  # moves files from $HOME into repo, replaces with symlinks
```

## Architecture

### Stow layout convention

Each package directory mirrors the path fragment that should appear under the target root:

- **User packages** (default): target is `$HOME`. Use `stow <package>`.
- **System packages** (`greetd`): target is `/`. Use `sudo stow --target=/ <package>`. These are listed in `ROOT_PACKAGES` in `setup.sh`.

- **XDG tools** use `package/.config/<app>/<files>` — stow creates `~/.config/<app>` as a symlink.
  - `hypr/.config/hypr/`, `ghostty/.config/ghostty/`, `nvim/.config/nvim/`, `waybar/.config/waybar/`, `wofi/.config/wofi/`
- **Non-XDG tools** place dotfiles directly at `package/.<file>` — stow creates `~/.<file>`.
  - `tmux/.tmux.conf`, `zsh/.zshrc`
- **Mixed packages** (`tmux`): combines a top-level dotfile (`.tmux.conf`) with XDG config paths (`.config/tmux/plugins/`). Stow handles both correctly.

### Packages

| Package | Tool | Key files |
|---------|------|-----------|
| `greetd` | greetd login manager (system config) | `etc/greetd/config.toml` |
| `hypr` | Hyprland compositor + Hyprlock + Hyprpaper | `hyprland.conf`, `hyprlock.conf`, `hyprpaper.conf`, `scripts/toggle_waybar.sh` |
| `ghostty` | Ghostty terminal | `config` |
| `nvim` | Neovim (lazy.nvim plugin manager) | `init.lua` (all config), `lazy-lock.json` (pinned plugin commits) |
| `tmux` | Tmux multiplexer + Catppuccin theme | `.tmux.conf` (prefix `C-s`, Catppuccin mocha), `.config/tmux/plugins/catppuccin/tmux/` (v2.3.0) |
| `waybar` | Waybar status bar | `config`, `style.css`, `power_menu.xml` |
| `wofi` | Wofi launcher | `config`, `style.css` |
| `zsh` | Zsh + Oh My Zsh | `.zshrc`, `clean_arch.sh`, `clear_clipboard.sh` |

### Design conventions

- **Dark theme** across all tools: black backgrounds (`#000000`, `#0a0c0f`, `#0D0D0D`), white text/borders.
- **Font**: `FiraCode Nerd Font` across all tools. Font size 22 in Ghostty.
- **Colorschemes**: Ghostty uses default dark background. Tmux uses Catppuccin Mocha via plugin. Neovim uses `lunaperche`. Zsh uses `garyblessington` Oh My Zsh theme.
- **Wayland-native toolchain**: Hyprland, Waybar, Wofi, Ghostty, Hyprlock, Hyprpaper, cliphist, wl-clipboard.
- **Single-file configs** where practical — Neovim uses a single `init.lua`; each tool has 1-3 files.
- **Claude Code routes through DeepSeek API** — configured via env vars in `.zshrc`. API keys are sourced from `~/.config/secrets/anthropic.env` (not tracked).

### Neovim plugin management

Plugins are managed by `lazy.nvim` (bootstrapped automatically if absent). The `lazy-lock.json` file pins all plugin commits and is versioned for reproducible setups. Key plugins: Telescope, Harpoon, Treesitter, Mason (LSP), nvim-cmp (completion), Fugitive (git), lunaperche (colorscheme).

### Tmux Catppuccin plugin

The Catppuccin theme for tmux is vendored into the repo at `tmux/.config/tmux/plugins/catppuccin/tmux/` (v2.3.0, cloned from `https://github.com/catppuccin/tmux.git`). It is loaded in `.tmux.conf` via `run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux`. To update:
```bash
cd ~/.config/tmux/plugins/catppuccin/tmux && git pull
cp -r ~/.config/tmux/plugins/catppuccin/tmux/ ~/.dotfiles/tmux/.config/tmux/plugins/catppuccin/
rm -rf ~/.dotfiles/tmux/.config/tmux/plugins/catppuccin/tmux/.git
```
