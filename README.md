# My dotfiles

Contains dotfiles for my system

## Requirements

### Stow
```
yay -S stow
```
## Use

First clone the repo
```
git clone git@github.com:ncastellanosort/dotfiles.git
cd dotfiles
```
Use GNU Stow to create symlinks
```
stow .
```
Add dotfile
```
cp -r ~/.config/dotfile ~/dotfiles
```
Warning problem
```
stow --adopt .
```
View symlinks
```
ls -lah ~/
```
