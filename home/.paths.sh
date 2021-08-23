#!/usr/bin/env bash

# Add homebrew /usr/local/sbin
[[ -d "/usr/local/sbin" ]] && export PATH="/usr/local/sbin:$PATH"

# Add local user bin
[[ -d "$HOME/.local/bin" ]] &&  export PATH="$HOME/.local/bin:$PATH"

# Add Amazon Builder Toolbox
[[ -d "$HOME/.toolbox/bin" ]] &&  export PATH="$HOME/.toolbox/bin:$PATH"

# Add Poetry
[[ -d "$HOME/.poetry/bin" ]] && export PATH="$HOME/.poetry/bin:$PATH"

# Add pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Add Visual Studio Code (code)
[[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Add Oracle Instant Client
if [[ -d "$HOME/env/tools/instantclient" ]]; then
    export TNS_ADMIN=$HOME/env/tools/instantclient
    export PATH=$PATH:$HOME/env/tools/instantclient
fi

# Export local JAVA_HOME
if [[ -x "/usr/libexec/java_home" ]]; then
    java_home=$(/usr/libexec/java_home)
    export JAVA_HOME=$java_home
fi

# Export local RUBY_CONFIGURE_OPTS
if command -v brew 1>/dev/null 2>&1 && brew --prefix openssl@1.1 1>/dev/null 2>&1; then
    openssl_directory="$(brew --prefix openssl@1.1)"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$openssl_directory"
fi
