echo "Loading: .bash_profile"

# If supported, enable globstar
if shopt -q globstar; then
    shopt -s globstar
fi

if shopt -q login_shell; then
	# Login Shell - Initialize Global Environment Variables
	echo "Login Shell"

	### PATH Extensions
	## Prefixes
	# Google Cloud SDK
	if [ -x ~/dev/tools/google-cloud-sdk/path.bash.inc ]; then
		source ~/dev/tools/google-cloud-sdk/path.bash.inc
	fi
	
	# Local Directories
	PATH=~/dev/bin:~/.local/bin:$PATH

	export PATH


	## Localization
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8


	## Tools Configuration
	# gpg
	export GPG_TTY=$(tty)

	# direnv
	export DIRENV_LOG_FORMAT=

    # pew
    export WORKON_HOME=~/.local/share/virtualenvs
    export PROJECT_HOME=~/dev/projects

	# pipenv
	export PIPENV_VENV_IN_PROJECT=1
    export PIPENV_SHELL_FANCY=1
	export PIPENV_DEFAULT_PYTHON_VERSION=3.7

	# pyenv
	if command -v pyenv 1>/dev/null 2>&1; then
		eval "$(pyenv init -)"
	fi

fi


# Load .bashrc to initialize Interactive / Non-Interactive Environments
source ~/.bashrc
