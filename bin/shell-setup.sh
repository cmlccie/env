#!/usr/bin/env bash

echo "==> Creating Development Folders"
mkdir -p ~/dev
mkdir -p ~/dev/certs
mkdir -p ~/dev/docker
mkdir -p ~/dev/learning
mkdir -p ~/dev/lib
mkdir -p ~/dev/projects
mkdir -p ~/dev/reference
mkdir -p ~/dev/sandbox
mkdir -p ~/dev/scratch
mkdir -p ~/dev/tmp
mkdir -p ~/dev/tools


# Timestamp for Renamed Files
timestamp=$(date -u +"%Y%m%dT%H%M%SZ")


echo "==> Creating Symbolic Links"
ln -sf ~/dev/shell/bin ~/dev/bin

if [ -f ~/.bash_profile ]; then
    echo "Backing up ~/.bash_profile to ~/.bash_profile.$timestamp"
    mv ~/.bash_profile ~/.bash_profile.$timestamp
fi
ln -sf ~/dev/shell/home/.bash_profile ~/.bash_profile

if [ -f ~/.bashrc ]; then
    echo "Backing up ~/.bashrc to ~/.bashrc.$timestamp"
    mv ~/.bashrc ~/.bashrc.$timestamp
fi
ln -sf ~/dev/shell/home/.bashrc ~/.bashrc

ln -sf ~/dev/shell/home/.gitignore_global ~/.gitignore_global


echo "==> Installing System Python Packages"
pip2 install --upgrade pip setuptools
pip3 install --upgrade pip setuptools
pip3 install --upgrade -r ~/dev/shell/sys3-requirements.txt


echo "==> Setting Up Fish Shell"
echo "Removing Old Fish Configurations"
rm -rf ~/.config/fish/
rm -rf ~/.config/omf/
rm -rf ~/.local/share/omf/
rm -rf ~/.local/share/fish/
rm -rf ~/.local/share/z/

echo "Installing OMF"
curl -L https://get.oh-my.fish | fish

echo "Installing Fisher"
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

echo "Configuring Fish Shell"
mkdir -p ~/.config/fish 
ln -sf ~/dev/shell/home/.config/fish/config.fish ~/.config/fish/config.fish

echo "Installing Fisher Plugins"
ln -sf ~/dev/shell/home/.config/fish/fishfile ~/.config/fish/fishfile
fish -c "fisher"
