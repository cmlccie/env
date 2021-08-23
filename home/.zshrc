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

        DEFAULT_USER=$(whoami)

        VIRTUAL_ENV_DISABLE_PROMPT=1

        ZSH_THEME="powerlevel10k/powerlevel10k"
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

        ENABLE_CORRECTION="true"
        COMPLETION_WAITING_DOTS="true"

        plugins=(aws chucknorris docker gitfast pipenv z)

        source "$ZSH/oh-my-zsh.sh"
    fi

    export LSCOLORS="exfxcxdxbxegedabagacad"

    ### Tool Configuration
    # pyenv
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)" > /dev/null
    fi

    # direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
    fi

    # isengardcli
    if command -v isengardcli 1>/dev/null 2>&1; then
        eval "$(isengardcli shell-profile --keep-prompt)"
    fi

    # iTerm
    if [[ -e ${HOME}/.iterm2_shell_integration.zsh ]]; then
        source "${HOME}/.iterm2_shell_integration.zsh"
    fi

    # travis
    if [[ -e ${HOME}/.travis/travis.sh ]]; then
        source "${HOME}/.travis/travis.sh"
    fi


    ### Zsh Aliases
    if [[ -e ${HOME}/.aliases.zsh ]]; then
        source "${HOME}/.aliases.sh"
    fi


else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv export zsh)"
    fi

fi
