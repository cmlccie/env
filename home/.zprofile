# echo "Loading: .zprofile"

if [[ -o login ]]; then
    # Login Shell
    # echo "Login Shell"

    ### Shell Configuration
    setopt extendedglob
    export SHELL="$(which zsh)"
    export EDITOR="code --wait"
    export LC_ALL="en_US.UTF-8"
    export LANG="en_US.UTF-8"

    # Local paths
    [[ -e ${HOME}/.paths.sh ]] && source "${HOME}/.paths.sh"

    # nvm
    [[ -d "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"

    # gpg
    export GPG_TTY="$(tty)"

    # direnv
    export DIRENV_LOG_FORMAT=""

    # poetry
    export POETRY_VIRTUALENVS_IN_PROJECT="true"

    # conda
    command -v conda 1>/dev/null 2>&1 && source $(conda info --root)/etc/profile.d/conda.sh

fi
