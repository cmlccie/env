# shellcheck shell=bash
# bash login shells. macOS /etc/profile runs path_helper before this; re-apply our PATH.
unset __SHELL_ENV
# shellcheck source=.config/shell/env.sh
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"

# Only interactive login shells get .bashrc. This is the fix for `bash -lc` printing output.
case $- in *i*) . "$HOME/.bashrc" ;; esac
