# shellcheck shell=sh
# Environment for EVERY shell, interactive or not. POSIX. Silent. Side-effect free.
# Loaded by: .zshenv, .zprofile, .bash_profile, .bashrc, .profile, $BASH_ENV.
# NEVER add here: aliases (zsh expands them non-interactively), prompts, completions,
# `eval "$(tool hook)"`, disk writes, or anything that prints.

# lib.sh loads ABOVE the sentinel: functions are not inherited across fork+exec, so a
# shell whose ancestor already ran env.sh must still get have()/source_if(). Defining
# functions is idempotent and fork-free, so re-running costs nothing.
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/lib.sh"

[ -n "$__SHELL_ENV" ] && return 0
export __SHELL_ENV=1

# XDG Base Directories -- defined here, located everywhere by the same expression.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# EDITOR is deliberately NOT set here -- it belongs to interactive sessions at a console.
# `false` (not `true`) so git ABORTS rather than accepting an unedited message: an agent
# that forgot -m gets a loud error, not a silent empty commit. interactive.sh overrides it.
export GIT_EDITOR=false

export DIRENV_LOG_FORMAT=""
export CILIUM_NAMESPACE="isovalent"

. "$XDG_CONFIG_HOME/shell/paths.sh"

# Bootstrap bare `bash -c` for AI agents. See README "Shell startup".
export BASH_ENV="$XDG_CONFIG_HOME/shell/env.sh"
