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

update_nix() {
    if command_exists devbox; then
        task "Rendering the devbox global manifest from nix/packages.json"
        # python3 rather than jq: this must work before Nix has provided jq.
        python3 - <<'PYTHON'
import json

manifest = json.load(open("nix/packages.json"))
# No "//" key here: devbox parses devbox.json into a Go struct, and an unknown
# key may be rejected. nix/packages.json carries the documentation.
rendered = {"packages": sorted(manifest["shared"] + manifest["host_only"])}
with open("nix/global.json", "w") as f:
    json.dump(rendered, f, indent=2)
    f.write("\n")
PYTHON

        task "Syncing the devbox global profile"
        # `pull --force` makes nix/global.json authoritative, so a package deleted from
        # nix/packages.json leaves the profile too. `devbox global add` cannot do that.
        devbox global pull --force nix/global.json
        devbox global install
        devbox global update
    else
        error "devbox is not installed -- curl -fsSL https://get.jetify.com/devbox | bash"
    fi
}

update_brew() {
    if command_exists brew; then
        task "Upgrading Homebrew Packages"
        # No `brew doctor`: once Nix is installed it warns permanently about the /nix
        # volume and unbrewed files, which trains you to ignore the output.
        brew update
        brew upgrade --yes
        # Enforce the Brewfile rather than merely documenting it. `if`, not `&&`: under
        # `set -e` a false `&&` list here would abort the run on Linux.
        # NOTE: this fails until the hand-installed GUI apps are adopted --
        #   brew install --cask --adopt docker-desktop visual-studio-code iterm2
        if [[ $(uname) == Darwin ]]; then
            brew bundle --file platforms/macos/Brewfile
        fi
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
            uv tool install ${tool}
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
        nix) nix=true; all=;;
        brew) brew=true; all=;;
        python|uv) python=true; all=;;
        conda) conda=true; all=;;
        node) node=true; all=;;
        rust) rust=true; all=;;
        completions) completions=true; all=;;
    esac
done

# Execute updates based on arguments
[[ ${nix} ]] || [[ ${all} ]] && update_nix
[[ ${brew} ]] || [[ ${all} ]] && update_brew
[[ ${python} ]] || [[ ${all} ]] && update_python
[[ ${conda} ]] || [[ ${all} ]] && update_conda
[[ ${node} ]] || [[ ${all} ]] && update_node
[[ ${rust} ]] || [[ ${all} ]] && update_rust
[[ ${completions} ]] || [[ ${all} ]] && update_completions
