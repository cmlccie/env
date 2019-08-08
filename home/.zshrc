# echo "Loading: .zshrc"

if [[ -o interactive ]]; then
	# Interactive Shell
	# echo "Interactive Shell"


    ### Shell Configuration
    if [[ -e ${HOME}/.oh-my-zsh ]]; then
        export ZSH=${HOME}/.oh-my-zsh

        DEFAULT_USER=chrlunsf

        ZSH_THEME="agnoster"
        AGNOSTER_PROMPT_SEGMENTS=(prompt_status prompt_virtualenv prompt_dir prompt_git prompt_end)

        ENABLE_CORRECTION="true"
        COMPLETION_WAITING_DOTS="true"

        plugins=(aws chucknorris docker gitfast pipenv pyenv vscode z)

        source $ZSH/oh-my-zsh.sh
    fi


    ### Tool Configuration
    # pew
    if command -v pew 1>/dev/null 2>&1; then
        source $(pew shell_config)
    fi

    # direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv hook zsh)"
    fi

    # iTerm
    if [[ -e ${HOME}/.iterm2_shell_integration.zsh ]]; then
        source ${HOME}/.iterm2_shell_integration.zsh
    fi

    # travis
    if [[ -e ${HOME}/.travis/travis.sh ]]; then
        source ${HOME}/.travis/travis.sh
    fi


    ### Zsh Aliases
    if [[ -e ${HOME}/.aliases.zsh ]]; then
        source ${HOME}/.aliases.zsh
    fi


else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv export zsh)"
    fi

fi
