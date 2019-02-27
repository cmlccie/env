#!/usr/bin/env fish


echo "===> Setting Up Fish Shell"
echo "==> Removing Old Fish Configurations"
rm -rf ~/.config/fish/
rm -rf ~/.local/share/fish/
rm -rf ~/.local/share/z/

echo "==> Configuring Fish Shell"
mkdir -p ~/.config/fish 
ln -sf ~/dev/shell/home/.config/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/dev/shell/home/.config/fish/functions ~/.config/fish/functions

echo "==> Installing Fisher"
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

echo "==> Installing Fisher Plugins"
ln -sf ~/dev/shell/home/.config/fish/fishfile ~/.config/fish/fishfile
fisher
