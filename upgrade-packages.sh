#!/usr/bin/env bash
# Upgrade system packages


cd "$(dirname "$0")" || exit


# Script arguments
all=true
for i in "${@}"; do
    case ${i} in
        brew)
        brew=true
        all=
        ;;

        poetry)
        poetry=true
        all=
        ;;

        sys2)
        sys2=true
        all=
        ;;

        sys3)
        sys3=true
        all=
        ;;

        conda)
        conda=true
        all=
        ;;

        node)
        node=true
        all=
        ;;
    esac
done


if command -v brew 1>/dev/null 2>&1 && { [[ ${brew} ]] || [[ ${all} ]]; }; then
    printf "\n==> Upgrading Homebrew Packages\n"
    brew update
    brew doctor
    brew upgrade
    brew cleanup
fi


if [[ ${poetry} ]] || [[ ${all} ]]; then
    printf "\n==> Installing/upgrading Python Poetry\n"
    if command -v poetry 1>/dev/null 2>&1; then
        printf "Updating poetry..."
        poetry self update
    
        update_status=$?
        if [[ $update_status -ne 0 ]]; then
            printf "Update failed. Removing existing poetry installalation."
            [[ -d "$HOME/Library/Application Support/pypoetry" ]] && rm -rf "$HOME/Library/Application Support/pypoetry"
            [[ -d "$HOME/.local/share/pypoetry" ]] && rm -rf "$HOME/.local/share/pypoetry"
        fi
    fi

    if ! [[ $(command -v poetry 1>/dev/null 2>&1) ]]; then
        printf "Installing poetry..."
        curl -sSL https://install.python-poetry.org | python3 -
    fi

    source "$HOME/.poetry/env"

    printf "Enabling poetry tab completion\n"
    # Bash (Homebrew)
    poetry completions bash > "$(brew --prefix)/etc/bash_completion.d/poetry.bash-completion"
    # Oh-My-Zsh
    mkdir -pv "$HOME/.oh-my-zsh/custom/plugins/poetry"
    poetry completions zsh > "$HOME/.oh-my-zsh/custom/plugins/poetry/_poetry"
fi


if { [[ ${sys2} ]] || [[ ${all} ]]; } && command -v pip2 --version 1>/dev/null 2>&1; then
    printf "\n==> Performing a clean install of the python2 system packages\n"

    sys2_packages=$(mktemp -t sys2_packages)

    printf "\nUninstalling existing Python2 (pip2) System Packages"
    pip2 freeze > "${sys2_packages}"
    pip2 uninstall -y -r "${sys2_packages}"

    printf "\nInstalling pip2 setup tools"
    pip2 install --upgrade pip setuptools wheel

    if [[ -f "python/sys2-requirements.txt" ]]; then
        printf "\nInstalling python2 (pip2) system packages from python/sys2-requirements.txt"
        sort -uo python/sys2-requirements.txt python/sys2-requirements.txt
        pip2 install --upgrade -r python/sys2-requirements.txt
    fi

    rm "${sys2_packages}"
fi


if { [[ ${sys3} ]] || [[ ${all} ]]; } && command -v pip3 --version 1>/dev/null 2>&1; then
    printf "\n==> Performing a clean install of the python3 system packages\n"

    sys3_packages=$(mktemp -t sys3_packages)

    printf "\nUninstalling existing Python3 (pip3) System Packages"
    pip3 freeze > "${sys3_packages}"
    pip3 uninstall -y -r "${sys3_packages}"

    printf "\nInstalling pip3 setup tools"
    pip3 install --upgrade pip setuptools wheel

    if [[ -f "python/sys3-requirements.txt" ]]; then
        printf "\nInstalling python3 system packages from python/sys3-requirements.txt"
        sort -uo python/sys3-requirements.txt python/sys3-requirements.txt
        pip3 install --upgrade -r python/sys3-requirements.txt
    fi

    rm "${sys3_packages}"
fi


if { [[ ${conda} ]] || [[ ${all} ]]; } && command -v conda 1>/dev/null 2>&1; then
    printf "\n==> Updating packages in the Conda base environment\n"
    conda update -n base --all -y
fi


if { [[ ${node} ]] || [[ ${all} ]]; } && command -v npm 1>/dev/null 2>&1; then
    if [[ -d "$NVM_DIR" ]]; then
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm use default
    fi

    printf "\n==> Updating packages in the Node global environment\n"
    npm update --location=global --no-fund
fi
