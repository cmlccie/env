#!/usr/bin/env bash
# Migrate an environment to the current dotfile conventions.
#
# Idempotent -- safe to re-run. Run once per machine after pulling this repo:
#   ~/dev/env/home/.local/bin/update-shell.sh
#
# Migrates:
#   - shell config consolidated into ~/.config/shell/{lib,paths,env,interactive,aliases}.sh
#   - global git ignore moved to git's default path, ~/.config/git/ignore
#   - legacy dotfiles removed (pyenv/conda/poetry init, flake8, cookiecutter, terraform, ...)

set -eu


# -----------------------------------------------------------------------------
# Output Formatting Functions
# -----------------------------------------------------------------------------

task() { printf "\033[34m==> %s\033[0m\n" "$1"; }    # Blue for new tasks
status() { printf "\033[37m    %s\033[0m\n" "$1"; }  # Grey for status updates
error() { printf "\033[31m==> %s\033[0m\n" "$1"; }   # Red for errors


# -----------------------------------------------------------------------------
# Locate the Repository
# -----------------------------------------------------------------------------

# This script is normally invoked through its ~/.local/bin symlink, so resolve
# the link before walking up to the repo root.
self="${BASH_SOURCE[0]}"
while [[ -L $self ]]; do self="$(readlink "$self")"; done
repo="$(cd "$(dirname "$self")/../../.." && pwd)"

[[ -x $repo/setup-home.py ]] || { error "cannot locate the env repo (resolved: $repo)"; exit 1; }


# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Remove a symlink only. Real files are left alone -- they may be local data.
remove_link() { [[ -L $1 ]] && rm -f "$1" && status "removed symlink $1"; return 0; }


# -----------------------------------------------------------------------------
# Migration Steps
# -----------------------------------------------------------------------------

remove_legacy_dotfiles() {
    task "Removing legacy dotfile symlinks"
    # Relocated into ~/.config/shell/
    remove_link "$HOME/.paths.sh"
    remove_link "$HOME/.paths.bash"
    remove_link "$HOME/.aliases.sh"
    # Retired tools
    remove_link "$HOME/.cookiecutterrc"
    remove_link "$HOME/.terraformrc"
    remove_link "$HOME/.config/flake8"
    remove_link "$HOME/.matplotlib/matplotlibrc"
    # Superseded by git's default ignore path, ~/.config/git/ignore
    remove_link "$HOME/.gitignore_global"

    rmdir "$HOME/.matplotlib" 2>/dev/null || true
}

install_dotfiles() {
    task "Installing dotfile symlinks"
    "$repo/setup-home.py"
}

reset_global_git_ignore() {
    task "Resetting the global git ignore path"
    # git reads $XDG_CONFIG_HOME/git/ignore by default; a custom path now shadows it.
    local current
    current="$(git config --global --get core.excludesfile || true)"
    [[ -z $current ]] && status "core.excludesfile already unset" && return 0

    git config --global --unset-all core.excludesfile
    status "unset core.excludesfile (was: $current)"
}

regenerate_completions() {
    task "Regenerating shell completions"
    "$repo/upgrade-packages.sh" completions
}

link_current_node() {
    task "Pointing \$NVM_DIR/current at the default node"
    # paths.sh puts $NVM_DIR/current/bin on PATH; nvm only creates it once `nvm use` runs.
    local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
    [[ -s $nvm_dir/nvm.sh ]] || { status "nvm not installed; skipping"; return 0; }

    export NVM_SYMLINK_CURRENT=true  # tells nvm to maintain the $NVM_DIR/current symlink
    # shellcheck source=/dev/null
    . "$nvm_dir/nvm.sh"
    nvm use default >/dev/null && status "current -> $(nvm current)"
}

report_backups() {
    task "Checking for backups left by setup-home.py"
    # Left in place deliberately -- these are copies of files that were not symlinks.
    find "$HOME" -maxdepth 3 -name '*.backup.*' -print 2>/dev/null | sed 's/^/    /'
    status "review and delete the files above once you are satisfied"
}

verify() {
    task "Verifying"
    local n
    for shell in "zsh -c" "zsh -lc" "bash -c" "bash -lc"; do
        n=$($shell true 2>&1 | wc -c | tr -d ' ')
        if [[ $n -eq 0 ]]; then status "$shell is silent"; else error "$shell emits $n bytes -- expected 0"; fi
    done

    command_exists git && status "git -> $(command -v git)"
    status "PATH duplicates: $(bash -lc 'echo $PATH' | tr : '\n' | sort | uniq -d | wc -l | tr -d ' ')"
}


# -----------------------------------------------------------------------------
# Main Script Execution
# -----------------------------------------------------------------------------

remove_legacy_dotfiles
install_dotfiles
reset_global_git_ignore
regenerate_completions
link_current_node
report_backups
verify

task "Done -- open a new terminal to pick up the new configuration"
