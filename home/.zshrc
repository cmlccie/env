# echo "Loading: .zshrc"

if [[ -o interactive ]]; then
    # Interactive Shell
    # echo "Interactive Shell"

    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi

    ### Shell Configuration
    export TERM="xterm-256color"

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

        source "$ZSH/oh-my-zsh.sh"
    fi

    export LSCOLORS="exfxcxdxbxegedabagacad"


    ### Tool Configuration
    # pyenv
    command -v pyenv 1>/dev/null && eval "$(pyenv init -)" > /dev/null

    # NVM
    [[ -e "${HOME}/.nvm" ]] && export NVM_DIR="${HOME}/.nvm"
    [[ -s "${NVM_DIR}/nvm.sh" ]] && source "${NVM_DIR}/nvm.sh"
    [[ -s "${NVM_DIR}/bash_completion" ]] && source "${NVM_DIR}/bash_completion"

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
    command -v direnv 1>/dev/null 2>&1 && eval "$(direnv export zsh)"

fi
