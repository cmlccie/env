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


echo "==> Creating Bash Profile Symbolic Links"
ln -sf ~/dev/shell/bin ~/dev/bin

if [ -f ~/.profile ]; then
    echo "Backing up ~/.profile to ~/.profile.$timestamp"
    mv ~/.profile ~/.profile.$timestamp
fi
ln -sf ~/dev/shell/home/.profile ~/.profile

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

if [ -f ~/.bash_aliases ]; then
    echo "Backing up ~/.bash_aliases to ~/.bash_aliases.$timestamp"
    mv ~/.bash_aliases ~/.bash_aliases.$timestamp
fi
ln -sf ~/dev/shell/home/.bash_aliases ~/.bash_aliases


echo "==> Configuring Git"
ln -sf ~/dev/shell/home/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
git config --global user.name "Chris Lunsford"
git config --global user.email "chris@cmlccie.com"


ln -sf ~/dev/shell/home/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -sf ~/dev/shell/home/.gnupg/gpg.conf ~/.gnupg/gpg.conf

ln -sf ~/dev/shell/home/.config/flake8 ~/.config/flake8

ln -sf ~/dev/shell/home/.matplotlib/matplotlibrc ~/.matplotlib/matplotlibrc


echo "==> Installing System Python Packages"
pip2 install --upgrade pip setuptools
pip3 install --upgrade pip setuptools
pip3 install --upgrade -r ~/dev/shell/sys3-requirements.txt
