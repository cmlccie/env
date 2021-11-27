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
    else
        printf "Installing poetry..."
        curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
    fi

    source "$HOME/.poetry/env"

    printf "Enabling poetry tab completion\n"
    # Bash (Homebrew)
    poetry completions bash > "$(brew --prefix)/etc/bash_completion.d/poetry.bash-completion"
    # Oh-My-Zsh
    mkdir -pv "$HOME/.oh-my-zsh/custom/plugins/poetry"
    poetry completions zsh > "$HOME/.oh-my-zsh/custom/plugins/poetry/_poetry"
fi


if [[ ${sys2} ]] || [[ ${all} ]]; then
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


if [[ ${sys3} ]] || [[ ${all} ]]; then
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


if command -v conda 1>/dev/null 2>&1 && { [[ ${conda} ]] || [[ ${all} ]]; }; then
    printf "\n==> Updating packages in the Conda base environment\n"
    conda update -n base --all -y
fi
