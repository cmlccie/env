#!/usr/bin/env zsh
# echo "Loading: .zshrc"


# Script functions
function command_exists { command -v 1>/dev/null 2>&1; }


# Configurations for interactive vs. non-interactive shell sessions
if [[ -o interactive ]]; then
    # Interactive Shell
    # echo "Interactive Shell"

    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    # if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
    #     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    # fi

    ### Tool Configuration
    # 1Password
    command_exists op && eval "$(op completion zsh)"; compdef _op op

    # direnv
    command_exists direnv && eval "$(direnv hook zsh)"

    # pyenv
    command_exists pyenv && echo "pyenv exists!!"
    command_exists pyenv && eval "$(pyenv init --path)" > /dev/null
    command_exists pyenv && eval "$(pyenv init -)" > /dev/null

    # conda
    command_exists conda && source "$(conda info --root)/etc/profile.d/conda.sh"

    # Node Version Manager (NVM)
    [[ -e "${HOME}/.nvm" ]] && export NVM_DIR="${HOME}/.nvm"
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"  # This loads nvm
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion

    # Twilio CLI
    command_exists twilio && eval "$(twilio autocomplete:script zsh)"

    # Kubernetes (kubectl)
    command_exists kubectl && source <(kubectl completion zsh)

    # iTerm
    [[ -e ${HOME}/.iterm2_shell_integration.zsh ]] && source "${HOME}/.iterm2_shell_integration.zsh"


    ### Aliases
    [[ -e ${HOME}/.aliases.sh ]] && source "${HOME}/.aliases.sh"


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
    # pyenv
    command -v pyenv 1>/dev/null && eval "$(pyenv init -)" > /dev/null

    # direnv
    command -v direnv 1>/dev/null 2>&1 && eval "$(direnv hook zsh)"

    # kubectl
    command -v kubectl 1>/dev/null 2>&1 && source <(kubectl completion zsh)

    # op
    command -v op 1>/dev/null 2>&1 && eval "$(op completion zsh)"; compdef _op op

    # Twilio CLI
    command -v twilio 1>/dev/null 2>&1 && eval $(twilio autocomplete:script zsh)

    # iTerm
    [[ -f "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"


    ### Aliases
    [[ -f ${HOME}/.aliases.sh ]] && source "${HOME}/.aliases.sh"

else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    command_exists direnv && eval "$(direnv export zsh)"

fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terragrunt terragrunt
