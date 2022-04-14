#!/usr/bin/env bash

# Oracle Instant Client
if [[ -d "$HOME/env/tools/instantclient" ]]; then
    export TNS_ADMIN=$HOME/env/tools/instantclient
    export PATH=$PATH:$HOME/env/tools/instantclient
fi

# Visual Studio Code (code)
[[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Homebrew
if command -v brew 1>/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

# AWS Amplify
[[ -d "$HOME/.amplify/bin" ]] && export PATH="$HOME/.amplify/bin:$PATH"

# Ruby
[[ -d "/usr/local/lib/ruby/gems/2.6.0/bin" ]] && export PATH="/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
[[ -d "/usr/local/opt/ruby/bin" ]] && export PATH="/usr/local/opt/ruby/bin:$PATH"

# Go
if command -v go 1>/dev/null 2>&1 && [[ -d "$HOME/.local/bin" ]]; then
    export GOBIN="$HOME/.local/bin"
fi

# pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Local user bin
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# PKG_CONFIG_PATH
[[ -d "/usr/local/lib" ]] && export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib"
[[ -d "/usr/local/lib/pkgconfig" ]] && export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"
[[ -d "/usr/local/opt/readline/lib/pkgconfig" ]] && export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/readline/lib/pkgconfig"

# PYTHONPATH
[[ -d "${HOME}/.local/lib" ]] && export PYTHONPATH="${HOME}/.local/lib:$PYTHONPATH"

# JAVA_HOME
if [[ -x "/usr/libexec/java_home" ]] && /usr/libexec/java_home 1>/dev/null 2>&1; then
    java_home=$(/usr/libexec/java_home)
    export JAVA_HOME=$java_home
fi

# RUBY_CONFIGURE_OPTS
if command -v brew 1>/dev/null 2>&1 && brew --prefix openssl@1.1 1>/dev/null 2>&1; then
    openssl_directory="$(brew --prefix openssl@1.1)"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$openssl_directory"
fi
