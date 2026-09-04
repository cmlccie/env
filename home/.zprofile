# zsh login shells. macOS /etc/zprofile runs path_helper AFTER .zshenv and BEFORE this
# file, hoisting /usr/bin ahead of Homebrew. Clear the sentinel and re-apply our PATH.
unset __SHELL_ENV
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
