#!/usr/bin/env fish


echo "===> Setting Up Fish Shell"

echo "==> Installing Fisher"
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

echo "==> Installing Fisher Plugins"
fisher
