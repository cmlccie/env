# echo "Loading: .zprofile"

if [[ -o login ]]; then
    # Login Shell
    # echo "Login Shell"

    ### Shell Configuration
    setopt extendedglob
    export SHELL=$(which zsh)
    export EDITOR=code
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    # Local paths
    if [[ -e ${HOME}/.paths.sh ]]; then
    	source "${HOME}/.paths.sh"
    fi

    # gpg
    export GPG_TTY=$(tty)

    # direnv
    export DIRENV_LOG_FORMAT=

    # poetry
    export POETRY_VIRTUALENVS_IN_PROJECT=true

    # conda
    if command -v conda 1>/dev/null 2>&1; then
        source $(conda info --root)/etc/profile.d/conda.sh
    fi

fi
