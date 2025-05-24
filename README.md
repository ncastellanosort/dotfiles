# My dotfiles
Config in another pc
```
git clone git@github.com:ncastellanosort/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```
Install stow
```
sudo pacman -S stow
```
Apply configs
```
stow tmux
```
Create symlink
```
cd ~/.doftiles
mkdir -p kitty/.config/kitty
```
```
mv ~/.config/kitty/* ~/.dotfiles/kitty/.config/kitty/
```
```
stow kitty
```
