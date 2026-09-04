# shellcheck shell=sh
# PATH construction. Lowest priority first -- path_prepend moves each entry to the front.
# Requires lib.sh. Sourced from env.sh only.

# Homebrew -- fork-free equivalent of `eval "$(brew shellenv)"`
[ -x /opt/homebrew/bin/brew ] && export HOMEBREW_PREFIX="/opt/homebrew" HOMEBREW_CELLAR="/opt/homebrew/Cellar" HOMEBREW_REPOSITORY="/opt/homebrew"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew" HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar" HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export HOMEBREW_NO_ENV_HINTS=1
# Guarded: an empty HOMEBREW_PREFIX would hoist /sbin and /bin to the front of PATH.
[ -n "$HOMEBREW_PREFIX" ] && path_prepend "$HOMEBREW_PREFIX/sbin"
[ -n "$HOMEBREW_PREFIX" ] && path_prepend "$HOMEBREW_PREFIX/bin"

# GUI-installed CLIs -- appended so they never shadow a real binary
path_append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
path_append "$HOME/.lmstudio/bin"

# Go
[ -d "$HOME/.go" ] && export GOPATH="$HOME/.go"
path_prepend "$HOME/.go/bin"

# Rust -- subsumes the untracked ~/.zshenv `. "$HOME/.cargo/env"`
[ -d "$HOME/.cargo" ] && export CARGO_HOME="$HOME/.cargo"
path_prepend "$HOME/.cargo/bin"

# Node -- nvm's `current` symlink; nvm itself is lazy-loaded in .zshrc only
export NVM_DIR="$HOME/.nvm"
export NVM_SYMLINK_CURRENT=true
path_prepend "$NVM_DIR/current/bin"

path_prepend "$HOME/.opencode/bin"
path_prepend "$HOME/.local/bin"

# WSL2: demote Windows /mnt/* entries so Linux binaries win. Must run after all path_* calls.
[ -n "$WSL_DISTRO_NAME" ] && PATH="$(printf %s "$PATH" | tr ':' '\n' | grep -v '^/mnt/' | paste -sd: -):$(printf %s "$PATH" | tr ':' '\n' | grep '^/mnt/' | paste -sd: -)"

export PATH
