# Interactive zsh only -- zsh does not source this file otherwise. No guard needed.

# powerlevel10k instant prompt. Keep at the very top; nothing above may write to
# stdout/stderr or read stdin.
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Normally already loaded by .zshenv; sentinel-guarded, so this is one test in that case.
# Keeps .zshrc self-sufficient if .zshenv is ever missing.
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"

setopt extendedglob

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="$USER"
DISABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
VIRTUAL_ENV_DISABLE_PROMPT="1"
NVM_LAZY_LOAD="true"
plugins=(aws docker gitfast z zsh-nvm)
source_if "$ZSH/oh-my-zsh.sh"

# Disable oh-my-zsh url-quote-magic
zle -D self-insert 2>/dev/null
zle -A .self-insert self-insert 2>/dev/null

# Aliases and shared interactive configuration
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/interactive.sh"

# Tool hooks -- interactive only; env.sh carries the env vars these tools read.
# Completions are generated to ~/.oh-my-zsh/completions by `upgrade-packages.sh completions`,
# which is already on fpath -- never regenerate them at shell startup.
have direnv && eval "$(direnv hook zsh)"

# Shell integrations
[[ -t 1 ]] && source_if "$HOME/.iterm2_shell_integration.zsh"
[[ "$TERM_PROGRAM" == "vscode" ]] && source_if "$(code --locate-shell-integration-path zsh)"

# powerlevel10k configuration -- p10k requires this LAST, after oh-my-zsh.sh
source_if "$HOME/.p10k.zsh"
