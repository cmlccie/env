#!/usr/bin/env bash
# echo "Loading: .bash_profile"

# If supported, enable globstar
if shopt -q globstar; then
    shopt -s globstar
fi

if shopt -q login_shell; then
    # Login Shell
    # echo "Login Shell"

    ### Shell Configuration
    export SHELL="$(which bash)"
    export EDITOR=code
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    ### Install Local Paths
    if [[ -e ${HOME}/.paths.bash ]]; then
        source "${HOME}/.paths.bash"
    fi

    ### Tools Configuration
    # gpg
    export GPG_TTY="$(tty)"

    # direnv
    export DIRENV_LOG_FORMAT=

    # poetry
    export POETRY_VIRTUALENVS_IN_PROJECT=true

    # pyenv
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi

    # conda
    if command -v conda 1>/dev/null 2>&1; then
        source "$(conda info --root)/etc/profile.d/conda.sh"
    fi

fi


# Load .bashrc to initialize Interactive / Non-Interactive Environments
source "${HOME}/.bashrc"
