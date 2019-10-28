# echo "Loading: config.fish"

if status --is-login
	# Login Shell
	# echo "Login Shell"

    ### Shell Configuration
    set -gx SHELL (which fish)
	set -gx EDITOR code
	set -gx LC_ALL en_US.UTF-8
	set -gx LANG en_US.UTF-8


	### Install Local Paths
	if test -e {$HOME}/.paths.fish
		source {$HOME}/.paths.fish
	end

	### Tool Configuration
	# gpg
	set -gx GPG_TTY (tty)

	# direnv
	set -gx DIRENV_LOG_FORMAT ""

	# virtualenv
	set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

    # pew
    set -gx WORKON_HOME {$HOME}/.local/share/virtualenvs
    set -gx PROJECT_HOME {$HOME}/dev/projects

	# pipenv
	set -gx PIPENV_VENV_IN_PROJECT 1
    set -gx PIPENV_SHELL_FANCY 1
	set -gx PIPENV_DEFAULT_PYTHON_VERSION 3.7

	# pyenv
	if command -vq pyenv
		pyenv init - | source
	end

	# conda
	if command -vq conda
		source (conda info --root)/etc/fish/conf.d/conda.fish
	end

end


if status --is-interactive
	# Interactive Shell
	# echo "Interactive Shell"

	### Shell Configuration
	set -gx theme_nerd_fonts yes

	### Tool Configuration
	# pew
	if command -vq pew
		source (pew shell_config)
	end

    # direnv
	if command -vq direnv
	    eval (direnv hook fish)
	end

	# iTerm2
	if test -e {$HOME}/.iterm2_shell_integration.fish
		source {$HOME}/.iterm2_shell_integration.fish
	end

else
	echo "Non-Interactive Shell"

	### Tool Configuration
    # direnv
	if command -vq direnv
    	eval (direnv export fish)
	end

end
