#!/usr/bin/env bash

echo "==> Upgrading Homebrew Packages"
brew update
brew doctor
brew upgrade


echo "==> Upgrading System Python Packages"
pip2 install --upgrade pip setuptools
pip3 install --upgrade pip setuptools
pip3 install --upgrade -r ~/dev/shell/sys3-requirements.txt


echo "==> Recreating dev3 Environment"
pew rm dev3
pew new -p python3 -r ~/dev/sandbox/dev3/requirements.txt dev3
