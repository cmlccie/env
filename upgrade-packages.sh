#!/usr/bin/env bash
# Upgrade system packages

set -e  # Exit immediately if a command exits with a non-zero status

cd "$(dirname "$0")" || exit


# --------------------------------------------------------------------------------------
# Helper Functions
# --------------------------------------------------------------------------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# Output Formatting Functions
# -----------------------------------------------------------------------------

task() {
    printf "\033[34m==> %s\033[0m\n" "$1"  # Blue for new tasks
}

status() {
    printf "\033[37m==> %s\033[0m\n" "$1"  # Grey for status updates
}

error() {
    printf "\033[31m==> %s\033[0m\n" "$1"  # Red for errors
}


# --------------------------------------------------------------------------------------
# Package Update Functions
# --------------------------------------------------------------------------------------

update_brew() {
    if command_exists brew; then
        task "Upgrading Homebrew Packages"
        brew update
        brew doctor || status "Brew doctor encountered issues, continuing..."
        brew upgrade
        brew cleanup
    else
        error "Homebrew is not installed"
    fi
}

update_poetry() {
    if command_exists poetry; then
        task "Upgrading Python Poetry"
        poetry self update || {
            error "Update failed. Removing existing poetry installation."
            [[ -d "$HOME/Library/Application Support/pypoetry" ]] && rm -rf "$HOME/Library/Application Support/pypoetry"
            [[ -d "$HOME/.local/share/pypoetry" ]] && rm -rf "$HOME/.local/share/pypoetry"

            status "Reinstalling poetry..."
            curl -sSL https://install.python-poetry.org | python3 -
        }

        status "Adding poetry plugins"
        poetry self add poetry-plugin-export

        status "Enabling poetry tab completion"
        poetry completions bash > "$(brew --prefix)/etc/bash_completion.d/poetry.bash-completion"
        mkdir -pv "$HOME/.oh-my-zsh/custom/plugins/poetry"
        poetry completions zsh > "$HOME/.oh-my-zsh/custom/plugins/poetry/_poetry"
    else
        error "Poetry is not installed"
    fi
}

update_python_packages() {
    if command_exists poetry; then
        task "Updating Python system packages using Poetry"
        poetry update --directory python/system-packages
    else
        error "Poetry is not installed"
    fi
}

update_conda() {
    if command_exists conda; then
        task "Updating packages in the Conda base environment"
        conda update --all -y
    else
        error "Conda is not installed"
    fi
}

update_node() {
    if command_exists npm; then
        if [[ -d ${NVM_DIR} ]]; then
            [[ -s ${NVM_DIR}/nvm.sh ]] && source "${NVM_DIR}/nvm.sh"
            nvm use default
            nvm install 'lts/*' --reinstall-packages-from=current
            nvm alias default node

            status "Installing the latest npm"
            nvm install-latest-npm

            status "Installing the latest yarn package manager"
            corepack enable
            corepack prepare yarn@stable --activate
        fi

        task "Updating packages in the Node global environment"
        npm update --location=global --no-fund
    else
        error "Node.js is not installed"
    fi
}

update_rust() {
    if command_exists rustup; then
        task "Updating Rust"
        rustup update
    else
        error "Rust is not installed"
    fi
}


# --------------------------------------------------------------------------------------
# Main Script Execution
# --------------------------------------------------------------------------------------

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
[[ ${python} ]] || [[ ${all} ]] && update_python_packages
[[ ${conda} ]] || [[ ${all} ]] && update_conda
[[ ${node} ]] || [[ ${all} ]] && update_node
[[ ${rust} ]] || [[ ${all} ]] && update_rust
