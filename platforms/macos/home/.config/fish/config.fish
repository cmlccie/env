# echo "Loading: config.fish"

if status --is-login
	# Login Shell - Initialize Global Environment Variables
	# echo "Login Shell"

    ### Fish Shell Configuration
    set -gx SHELL /usr/local/bin/fish
	set -gx LC_ALL en_US.UTF-8
	set -gx LANG en_US.UTF-8
	set -gx GREP_OPTIONS '--color auto'
	# set -gx theme_powerline_fonts yes
	set -gx theme_nerd_fonts yes


	### PATH Extensions
	## Prefixes
	# Local Directories
	set -gx PATH ~/dev/bin ~/.local/bin $PATH

	## Suffixes
	# Visual Studio Code
	set -gx PATH $PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


	### PKG_CONFIG_PATH Extensions
	set -gx PKG_CONFIG_PATH /usr/local/lib /usr/local/lib/pkgconfig $PKG_CONFIG_PATH


	### PYTHONPATH Extensions
	set -gx PYTHONPATH ~/dev/lib $PYTHONPATH


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
	set -gx PIPENV_DEFAULT_PYTHON_VERSION 3.6


end


if status --is-interactive
    # Interactive Shell
	# echo "Interactive Shell"

    ### Shell Tools
    ## pyenv
    source (pyenv init -|psub)

	## pew
	source (pew shell_config)

	## powerline
	# Color Scheme:
	set -g theme_color_scheme user

	#               light  medium dark
	#               ------ ------ ------
	set -l black    000000
	set -l white	ffffff e0e0e0
	set -l grey     666666 525252 525252
	set -l blue     unused 0096D6 2970a6
	set -l green    C1CD23 46A040
	set -l purple	652D89
	set -l red		unused E31B23 C41230
	set -l orange   F58025
	set -l yellow	FFE14F

      set __color_initial_segment_exit     $white[1]	$red[2]		--bold
      set __color_initial_segment_su       $white[1]	$green[2]	--bold
      set __color_initial_segment_jobs     $white[1]	$blue[3]	--bold

      set __color_path                     $grey[2]		$white[2]
      set __color_path_basename            $grey[2]		$white[1]	--bold
      set __color_path_nowrite             $red[3]		$white[2]
      set __color_path_nowrite_basename    $red[3]		$white[1]	--bold

      set __color_repo                     $green[1]	$grey[3]
      set __color_repo_work_tree           $grey[2]		$white[2]	--bold
      set __color_repo_dirty               $red[3]		$white[2]
      set __color_repo_staged              $orange		$grey[3]

      set __color_vi_mode_default          $grey[2]		$white[2]	--bold
      set __color_vi_mode_insert           $green[2]	$white[2]	--bold
      set __color_vi_mode_visual           $orange		$white[2]	--bold

      set __color_vagrant                  $purple		$white[2]	--bold
      set __color_k8s                      $green[2] 	$white[1]	--bold
      set __color_username                 $grey[1]		$blue[2]	--bold
      set __color_hostname                 $grey[1]		$blue[2]
      set __color_rvm                      $red[2]		$white[2]	--bold
      set __color_virtualfish              $blue[2]		$white[2]	--bold
      set __color_virtualgo                $blue[2]		$white[2]	--bold


    ### Interactive Environment Variable Management
    ## direnv
    eval (direnv hook fish)


else
    # Non-Interactive Shell
	# echo "Non-Interactive Shell"

    ### Non-Interactive Environment Variable Management
    ## direnv
    eval (direnv export fish)


end
