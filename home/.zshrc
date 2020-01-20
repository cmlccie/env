# echo "Loading: .zshrc"

if [[ -o interactive ]]; then
	# Interactive Shell
	# echo "Interactive Shell"


    ### Shell Configuration
    export TERM="xterm-256color"

    if [[ -e ${HOME}/.oh-my-zsh ]]; then
        export ZSH=${HOME}/.oh-my-zsh

        DEFAULT_USER=chrlunsf

        VIRTUAL_ENV_DISABLE_PROMPT=1

        POWERLEVEL9K_MODE='nerdfont-complete'
        POWERLEVEL9K_STATUS_CROSS='true'
        # POWERLEVEL9K_STATUS_OK=false
        POWERLEVEL9K_SHORTEN_DIR_LENGTH='1'
        POWERLEVEL9K_SHORTEN_DELIMITER=""
        POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
        POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="015"
        POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD='0'
        POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='245'
        POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'
        POWERLEVEL9K_TIME_BACKGROUND='255'
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator virtualenv anaconda dir dir_writable vcs)
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time time)
        ZSH_THEME="powerlevel9k/powerlevel9k"

        ENABLE_CORRECTION="true"
        COMPLETION_WAITING_DOTS="true"

        # pyenv 
        plugins=(aws chucknorris docker gitfast pipenv z)

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
