# Dotfiles README

This repository contains my personal dotfiles managed with **GNU Stow**.

## Core Concept

* Each directory in this repo is a "package" (`nvim`, `tmux`, `ghostty`, etc).
* Stow creates symlinks from this repo into `$HOME`.
* The real files live **ONLY** in this repository.

---

## Requirements

* `git`
* `GNU Stow`

**Example (Arch Linux):**

```bash
sudo pacman -S git stow

```

---

## Setup on a NEW machine (Migration)

### Quick setup (recommended)

```bash
bash setup.sh
```

That’s it. The script checks prerequisites, clones the repo, and stows all packages.

### Manual setup

#### 1. Clone the repository

```bash
git clone git@github.com:ncastellanosort/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

#### 2. Apply configurations

```bash
stow nvim
stow tmux
stow ghostty
# ... or stow individual packages as needed
```

Stow creates symlinks like:

* `~/.config/nvim`  -> `~/.dotfiles/nvim`
* `~/.config/ghostty` -> `~/.dotfiles/ghostty/.config/ghostty`

> [!IMPORTANT]
> You should **NOT** move files from `~/.config` on a new machine. New machines start empty; stow only creates symlinks.

---

## Using stow with verbosity (`-v`)

To see exactly what symlinks stow is creating, use:

```bash
stow -v nvim

```

This prints each symlink operation, which is useful for:

* Debugging.
* Understanding where files are going.
* Verifying nothing unexpected happens.

**Example output (simplified):**

```text
LINK: .config/nvim/init.lua -> ../../.dotfiles/nvim/init.lua

```

---

## Removing symlinks (`-D`)

To **REMOVE** (unstow) a package and delete its symlinks:

```bash
stow -D nvim

```

**This does the following:**

* Removes the symlinks from `$HOME`.
* **DOES NOT** delete files inside `~/.dotfiles`.

**Use this when:**

* Restructuring a package.
* Fixing a broken layout.
* Temporarily disabling a config.

---

## Adopting existing configs (`--adopt`)

`--adopt` is used **ONLY** when you already have config files in `$HOME` and want to move them into this repository.

**Example:**

```bash
stow --adopt ghostty

```

**What this does:**

* Moves files from `~/.config/ghostty` into `~/.dotfiles/ghostty/...`.
* Replaces them with symlinks.

> [!CAUTION]
> * `--adopt` is a **ONE-TIME** operation.
> * **DO NOT** use it on a new machine.
> * **DO NOT** use it casually.
> * Think of it as: *"Convert existing config into dotfiles"*, **NOT** as *"Apply config"*.
> 
> 

---

## Adding a new application (First time only)

### 1. Create the package structure

```bash
mkdir -p ~/.dotfiles/ghostty/.config/ghostty

```

### 2. Move existing config (once)

```bash
mv ~/.config/ghostty/* ~/.dotfiles/ghostty/.config/ghostty/

```

### 3. Apply it with stow

```bash
cd ~/.dotfiles
stow ghostty

```

After this, future machines only need: `stow ghostty`.

---

## Notes

* **Runtime data is NOT tracked:** e.g., `~/.cache`, `~/.local/share`.
* **Neovim plugins:** Managed by `lazy.nvim`. The `lazy-lock.json` **IS** versioned for reproducibility.

---

## Mental Model

`stow <package>` = *"Make my HOME look like this package exists here"*.

> **Note:** If stow is linking only a single file, the layout is likely wrong.

---
