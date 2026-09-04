# POSIX login shells (dash, sh) and Linux display managers. No bashisms -- this file may
# be read by dash as /bin/sh. bash prefers .bash_profile, so this does not double-load.
unset __SHELL_ENV
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
