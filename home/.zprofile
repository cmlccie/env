#!/usr/bin/env zsh
# echo "Loading: .zprofile"

if [[ -o login ]]; then
    # Login Shell
    # echo "Login Shell"

    # Local paths
    [[ -e ${HOME}/.paths.sh ]] && source "${HOME}/.paths.sh"

    ### Shell Configuration
    setopt extendedglob
    export SHELL="$(which zsh)"
    export EDITOR="code --wait"
    export LC_ALL="en_US.UTF-8"
    export LANG="en_US.UTF-8"

    # XDG Base Directories
    export XDG_CONFIG_HOME="${HOME}/.config"
    export XDG_CACHE_HOME="${HOME}/.cache"
    export XDG_DATA_HOME="${HOME}/.local/share"
    export XDG_STATE_HOME="${HOME}/.local/state"

    # nvm
    [[ -d "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"

    # gpg
    export GPG_TTY="$(tty)"

    # direnv
    export DIRENV_LOG_FORMAT=""

    # poetry
    export POETRY_VIRTUALENVS_IN_PROJECT="true"

    # conda
    command -v conda 1>/dev/null 2>&1 && source "$(conda info --base)/etc/profile.d/conda.sh"

    # Isovalent
    export CILIUM_NAMESPACE="isovalent"

fi
