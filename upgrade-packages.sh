#!/usr/bin/env bash
# Upgrade system packages

set -e  # Exit immediately if a command exits with a non-zero status

cd "$(dirname "$0")" || exit

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Functions for package updates
update_brew() {
    if command_exists brew; then
        printf "\n==> Upgrading Homebrew Packages\n"
        brew update
        brew doctor
        brew upgrade
        brew cleanup
    else
        printf "\nError: Homebrew is not installed\n"
    fi
}

update_poetry() {
    if command_exists poetry; then
        printf "\n==> Upgrading Python Poetry\n"
        poetry self update || {
            printf "\nUpdate failed. Removing existing poetry installation.\n"
            [[ -d "$HOME/Library/Application Support/pypoetry" ]] && rm -rf "$HOME/Library/Application Support/pypoetry"
            [[ -d "$HOME/.local/share/pypoetry" ]] && rm -rf "$HOME/.local/share/pypoetry"

            printf "\nReinstalling poetry...\n"
            curl -sSL https://install.python-poetry.org | python3 -
        }

        printf "\nAdding poetry plugins\n"
        poetry self add poetry-plugin-export

        printf "\nEnabling poetry tab completion\n"
        poetry completions bash > "$(brew --prefix)/etc/bash_completion.d/poetry.bash-completion"
        mkdir -pv "$HOME/.oh-my-zsh/custom/plugins/poetry"
        poetry completions zsh > "$HOME/.oh-my-zsh/custom/plugins/poetry/_poetry"
    else
        printf "\nError: Poetry is not installed\n"
    fi
}

update_python_packages() {
    local python_version=$1
    local requirements_file=$2

    if command_exists "$python_version"; then
        printf "\n==> Performing a clean install of the $python_version system packages\n"

        local temp_packages
        temp_packages=$(mktemp -t "${python_version}_packages")

        printf "\nUninstalling existing $python_version System Packages\n"
        "$python_version" freeze > "$temp_packages"
        "$python_version" uninstall -y -r "$temp_packages"

        printf "\nInstalling $python_version setup tools\n"
        "$python_version" install --upgrade pip setuptools wheel

        if [[ -f "$requirements_file" ]]; then
            printf "\nInstalling $python_version system packages from $requirements_file\n"
            sort -uo "$requirements_file" "$requirements_file"
            "$python_version" install --upgrade -r "$requirements_file"
        fi

        rm "$temp_packages"
    else
        printf "\nError: $python_version is not installed\n"
    fi
}

update_conda() {
    if command_exists conda; then
        printf "\n==> Updating packages in the Conda base environment\n"
        conda update --all -y
    else
        printf "\nError: Conda is not installed\n"
    fi
}

update_node() {
    if command_exists npm; then
        if [[ -d ${NVM_DIR} ]]; then
            [[ -s ${NVM_DIR}/nvm.sh ]] && source "${NVM_DIR}/nvm.sh"
            nvm use default
            nvm install 'lts/*' --reinstall-packages-from=current
            nvm alias default node

            printf "\n==> Installing the latest npm\n"
            nvm install-latest-npm

            printf "\n==> Installing the latest yarn package manager\n"
            corepack enable
            corepack prepare yarn@stable --activate
        fi

        printf "\n==> Updating packages in the Node global environment\n"
        npm update --location=global --no-fund
    else
        printf "\nError: Node.js is not installed\n"
    fi
}

update_rust() {
    if command_exists rustup; then
        printf "\n==> Updating Rust\n"
        rustup update
    else
        printf "\nError: Rust is not installed\n"
    fi
}

# Script arguments
all=true
for i in "${@}"; do
    case ${i} in
        brew) brew=true; all=;;
        poetry) poetry=true; all=;;
        python) python=true; all=;;
        conda) conda=true; all=;;
        node) node=true; all=;;
        rust) rust=true; all=;;
    esac
done

# Execute updates based on arguments
[[ ${brew} ]] || [[ ${all} ]] && update_brew
[[ ${poetry} ]] || [[ ${all} ]] && update_poetry
[[ ${python} ]] || [[ ${all} ]] && update_python_packages pip3 python/sys3-requirements.txt
[[ ${conda} ]] || [[ ${all} ]] && update_conda
[[ ${node} ]] || [[ ${all} ]] && update_node
[[ ${rust} ]] || [[ ${all} ]] && update_rust
