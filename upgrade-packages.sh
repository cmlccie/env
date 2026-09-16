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
        brew upgrade --yes
        brew cleanup
    else
        error "Homebrew is not installed"
    fi
}

update_python() {
    if command_exists uv; then
        task "Upgrading uv"
        # Fails when uv is externally managed (Homebrew, apt); that owner upgrades it.
        uv self update 2>/dev/null || status "uv is externally managed; skipping self-update"

        task "Installing Python CLI tools from python/uv-tools.txt"
        # Already-installed tools are a no-op, so this doubles as the bootstrap.
        while read -r tool; do
            [[ -z ${tool} || ${tool} == \#* ]] && continue
            # shellcheck disable=SC2086  # word splitting is how extras reach uv
            uv tool install ${tool} --force
        done < python/uv-tools.txt

        task "Upgrading Python CLI tools"
        uv tool upgrade --all

        task "Upgrading uv-managed Python interpreters"
        # Tolerated: a machine with no uv-managed interpreters must not abort the run.
        uv python upgrade || status "No uv-managed interpreters to upgrade"
    else
        error "uv is not installed -- see https://docs.astral.sh/uv/getting-started/installation/"
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

update_completions() {
    # Generated here, never at shell startup. ~/.oh-my-zsh/completions is already on fpath.
    task "Regenerating shell completions"
    mkdir -p "$HOME/.oh-my-zsh/completions"
    for t in docker kubectl cilium tetra op; do
        command_exists "$t" && "$t" completion zsh > "$HOME/.oh-my-zsh/completions/_$t"
    done

    # Tools that spell the subcommand differently.
    if command_exists uv; then
        uv generate-shell-completion zsh > "$HOME/.oh-my-zsh/completions/_uv"
        uvx --generate-shell-completion zsh > "$HOME/.oh-my-zsh/completions/_uvx"
    fi
    if command_exists poetry; then
        poetry completions zsh > "$HOME/.oh-my-zsh/completions/_poetry"
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
        python|uv) python=true; all=;;
        conda) conda=true; all=;;
        node) node=true; all=;;
        rust) rust=true; all=;;
        completions) completions=true; all=;;
    esac
done

# Execute updates based on arguments
[[ ${brew} ]] || [[ ${all} ]] && update_brew
[[ ${python} ]] || [[ ${all} ]] && update_python
[[ ${conda} ]] || [[ ${all} ]] && update_conda
[[ ${node} ]] || [[ ${all} ]] && update_node
[[ ${rust} ]] || [[ ${all} ]] && update_rust
[[ ${completions} ]] || [[ ${all} ]] && update_completions
