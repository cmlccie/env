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

ensure_system_login_shell() {
    task "Ensuring the login shell is /bin/zsh"
    # The devbox global profile is a nix generations symlink under ~/.local/share, which
    # must never be a login shell; brew's zsh is going away. macOS ships zsh 5.9.
    # dscl is macOS-only and fails inside sandboxes; $SHELL is the portable fallback.
    local current=""
    if command_exists dscl; then
        current="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')" || true
    fi
    [[ -n $current ]] || current="${SHELL:-}"
    [[ $current == /bin/zsh ]] && status "already /bin/zsh" && return 0
    [[ -x /bin/zsh ]] || { status "/bin/zsh not present; skipping"; return 0; }

    status "login shell is ${current:-unknown} -- chsh will prompt for your password"
    chsh -s /bin/zsh && status "login shell -> /bin/zsh"
}

unpin_gpg_program() {
    task "Unpinning git's gpg.program from an absolute path"
    # ~/.gitconfig pinned /opt/homebrew/bin/gpg while commit.gpgsign is true, so removing
    # the Homebrew gnupg would break every signed commit. Let PATH resolve it instead.
    local current
    current="$(git config --global --get gpg.program || true)"
    [[ $current == /* ]] || { status "gpg.program is not an absolute path"; return 0; }

    git config --global gpg.program gpg
    status "gpg.program: $current -> gpg"
}

migrate_tfenv_root() {
    task "Moving the tfenv version root to its XDG data location"
    # The nixpkgs tfenv wrapper defaults TFENV_CONFIG_DIR to $XDG_DATA_HOME/tfenv;
    # Homebrew's tfenv used ~/.config/tfenv. Without this, installed Terraform
    # versions and the pinned .terraform-version silently disappear.
    local src="${XDG_CONFIG_HOME:-$HOME/.config}/tfenv"
    local dst="${XDG_DATA_HOME:-$HOME/.local/share}/tfenv"
    [[ -d $src ]] || { status "no $src to move"; return 0; }
    [[ -e $dst ]] && { status "$dst already exists; leaving $src in place"; return 0; }

    mv "$src" "$dst" && status "moved $src -> $dst"
}

install_nix_packages() {
    task "Installing Nix packages via devbox global"
    command_exists devbox || { status "devbox is not installed; skipping"; return 0; }
    "$repo/upgrade-packages.sh" nix
}

restart_gpg_agent() {
    task "Restarting gpg-agent"
    # Picks up the new pinentry and gpg paths without a logout.
    command_exists gpgconf && gpgconf --kill gpg-agent || true
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

    status "PATH duplicates: $(bash -lc 'echo $PATH' | tr : '\n' | sort | uniq -d | wc -l | tr -d ' ')"

    # After the migration each of these should resolve under the devbox global profile
    # (or ~/.local/bin for uv tool binaries) -- never /opt/homebrew/bin.
    for t in git kubectl yq uv terraform helm gpg; do
        command_exists "$t" && status "$t -> $(command -v "$t")"
    done
    command_exists devbox && status "devbox global -> $(devbox global path 2>/dev/null)"
    return 0
}


# -----------------------------------------------------------------------------
# Main Script Execution
# -----------------------------------------------------------------------------

remove_legacy_dotfiles
install_dotfiles
ensure_system_login_shell
reset_global_git_ignore
unpin_gpg_program
migrate_tfenv_root
install_nix_packages
restart_gpg_agent
regenerate_completions
link_current_node
report_backups
verify

task "Done -- open a new terminal to pick up the new configuration"
