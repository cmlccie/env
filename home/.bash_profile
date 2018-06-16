echo "Loading: .bash_profile"

# if shopt -q login_shell; then; echo "Login Shell"; fi


### Initialize Global "Login Shell" Environment
## PATH Modifications
# Includes user's private bin directories
export PATH=$HOME/dev/bin:$HOME/bin:$HOME/.local/bin:$PATH

# Include user's local development packages
export PYTHONPATH=$HOME/dev/lib:$PYTHONPATH


## Localization
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


## Tools Configuration
# direnv
export DIRENV_LOG_FORMAT=

# pip
# export PIP_REQUIRE_VIRTUALENV=true

# pew
export WORKON_HOME=~/.local/share/virtualenvs
export PROJECT_HOME=~/dev/projects

# pipenv
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_DEFAULT_PYTHON_VERSION=3.6


### Load .bashrc to initialize Interactive / Non-Interactive Environments
source ~/.bashrc
