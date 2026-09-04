# shellcheck shell=bash
# Interactive bash only.
# sshd sources this file even non-interactively for `ssh host cmd`, so the early return
# is what keeps scp/rsync/git-over-ssh clean.
case $- in *i*) ;; *) return ;; esac

# shellcheck source=.config/shell/env.sh
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
# shellcheck source=.config/shell/interactive.sh
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/interactive.sh"

shopt -s globstar checkwinsize histappend
HISTCONTROL=ignoreboth

# No PS1 -- bash's default is left alone deliberately. Interactive bash here exists for
# agents, which parse output; a custom prompt with ANSI escapes is one more thing to strip.
# For a human-facing prompt, source ~/.local/bin/simple-prompt.sh on demand.

have direnv && eval "$(direnv hook bash)"
[[ -t 1 ]] && source_if "$HOME/.iterm2_shell_integration.bash"
