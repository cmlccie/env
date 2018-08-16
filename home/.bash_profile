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


	### PKG_CONFIG_PATH Extensions
	export PKG_CONFIG_PATH=/usr/local/lib:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH


	### PYTHONPATH Extensions
	export PYTHONPATH=~/dev/lib:$PYTHONPATH


	### Console Configuration
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export CLICOLOR=1
	export GREP_OPTIONS='--color=auto'


	### App Configuration
	## gpg
	export GPG_TTY=$(tty)

	## direnv
	export DIRENV_LOG_FORMAT=

	## pip
	# export PIP_REQUIRE_VIRTUALENV=true

    ## pew
    export WORKON_HOME=~/.local/share/virtualenvs
    export PROJECT_HOME=~/dev/projects

	## pipenv
	export PIPENV_VENV_IN_PROJECT=1
    export PIPENV_SHELL_FANCY=1
	export PIPENV_DEFAULT_PYTHON_VERSION=3.7

fi

# Load .bashrc to initialize Interactive / Non-Interactive Environments
source ~/.bashrc
