#!/usr/bin/env bash
# macOS Development Environment Setup


echo "==> Installing Xcode Tools"
xcode-select --install
echo "Installing additional SDK headers"
# See https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /


echo "==> Installing Homebrew Packages"
if [ ! -x /usr/local/bin/brew ]; then
echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update
brew doctor
brew bundle install --file=~/dev/shell/macos/Brewfile


echo "==> Creating Symbolic Links"
ln -sf /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code
