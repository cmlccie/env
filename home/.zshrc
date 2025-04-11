#!/usr/bin/env zsh
# echo "Loading: .zshrc"


# Script functions
function command_exists { command -v $1 1>/dev/null 2>&1; }


# Configurations for interactive vs. non-interactive shell sessions
if [[ -o interactive ]]; then
    # Interactive Shell

    ### Shell Configuration
    export TERM="xterm-256color"
    export LSCOLORS="exfxcxdxbxegedabagacad"

    if [[ -e ${HOME}/.oh-my-zsh ]]; then
        export ZSH="${HOME}/.oh-my-zsh"

        DEFAULT_USER="$(whoami)"

        VIRTUAL_ENV_DISABLE_PROMPT="1"

        ZSH_THEME="powerlevel10k/powerlevel10k"
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

        ENABLE_CORRECTION="true"
        COMPLETION_WAITING_DOTS="true"

        plugins=(aws chucknorris docker gitfast z zsh-nvm)

        source "${ZSH}/oh-my-zsh.sh"
    fi


    ### Tool Configuration
    # 1Password
    command_exists op && eval "$(op completion zsh)"; compdef _op op

    # direnv
    command_exists direnv && eval "$(direnv hook zsh)"

    # pyenv
    command_exists pyenv && eval "$(pyenv init -)" > /dev/null

    # conda
    command_exists conda && source "$(conda info --root)/etc/profile.d/conda.sh"

    # Node Version Manager (NVM)
    [[ -e "${HOME}/.nvm" ]] && export NVM_DIR="${HOME}/.nvm"
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

    # Kubernetes (kubectl)
    command_exists kubectl && source <(kubectl completion zsh)

    # iTerm
    [[ -e ${HOME}/.iterm2_shell_integration.zsh ]] && source "${HOME}/.iterm2_shell_integration.zsh"


    ### Aliases
    [[ -e ${HOME}/.aliases.sh ]] && source "${HOME}/.aliases.sh"

else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    command_exists direnv && eval "$(direnv export zsh)"

    # pyenv
    command_exists pyenv && eval "$(pyenv init --path)" > /dev/null

fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terragrunt terragrunt
