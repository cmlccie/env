# shellcheck shell=sh
# Shared bash + zsh interactive configuration. Sourced ONLY from .zshrc and .bashrc.
# Nothing here reaches a non-interactive shell -- that is the whole point of the file.

export CLICOLOR=1
export LSCOLORS="exfxcxdxbxegedabagacad"
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Needs a real tty: $(tty) yields the literal string "not a tty" non-interactively.
GPG_TTY="$(tty)"
export GPG_TTY

# A blocking editor is only ever correct when a human is at the console.
# Overrides env.sh's GIT_EDITOR=false, which stays in force for agents and scripts.
have code && export EDITOR="code --wait"
have code || export EDITOR="vi"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

source_if "$XDG_CONFIG_HOME/shell/aliases.sh"
