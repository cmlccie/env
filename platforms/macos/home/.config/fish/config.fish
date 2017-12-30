#echo "Loading: config.fish"

if status --is-login
	# Login Shell - Initialize Global Environment Variables

    ### Ensure SHELL is set to fish
    set -gx SHELL /usr/local/bin/fish


	### PATH Extensions
	## Prefixes
	# Local Directories
	set -gx PATH ~/dev/bin ~/.local/bin $PATH

	## Suffixes
	# Visual Studio Code
	set -gx PATH $PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


	### PYTHONPATH Extensions
	set -gx PYTHONPATH ~/dev/lib $PYTHONPATH


	### Console Configuration
	set -gx LC_ALL en_US.UTF-8
	set -gx LANG en_US.UTF-8
	set -gx GREP_OPTIONS '--color auto'


	### App Configuration
	## direnv
	set -gx DIRENV_LOG_FORMAT

	## pip
	#set -gx PIP_REQUIRE_VIRTUALENV true

    ## pew
    set -gx WORKON_HOME ~/.local/share/virtualenvs
    set -gx PROJECT_HOME ~/dev/projects

	## pipenv
	set -gx PIPENV_VENV_IN_PROJECT 1
    set -gx PIPENV_SHELL_FANCY 1


end


if status --is-interactive
    # Interactive Shell

    ### Shell Tools
    ## pyenv
    source (pyenv init -|psub)

	## pew
	source (pew shell_config)

    ### Interactive Environment Variable Management
    ## direnv
    eval (direnv hook fish)


else
    # Non-Interactive Shell

    ### Non-Interactive Environment Variable Management
    ## direnv
    eval (direnv export fish)


end
