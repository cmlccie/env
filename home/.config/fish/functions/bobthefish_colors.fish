# Color Scheme:
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

function bobthefish_colors -S -d 'Custom Cisco Color Scheme'
    ___bobthefish_colors default

    # then override everything you want! note that these must be defined with `set -x`
    set -x color_initial_segment_exit		$white[1] $red[2] --bold
    set -x color_initial_segment_su			$white[1] $green[2] --bold
    set -x color_initial_segment_jobs     	$white[1] $blue[3] --bold

    set -x color_path                     	$grey[2] $white[2]
    set -x color_path_basename            	$grey[2] $white[1] --bold
    set -x color_path_nowrite             	$red[3] $white[2]
    set -x color_path_nowrite_basename    	$red[3] $white[1] --bold

    set -x color_repo                     	$green[1] $grey[3]
    set -x color_repo_work_tree           	$grey[2] $white[2] --bold
    set -x color_repo_dirty               	$red[3] $white[2]
    set -x color_repo_staged              	$orange $grey[3]

    set -x color_vi_mode_default          	$grey[2] $white[2] --bold
    set -x color_vi_mode_insert           	$green[2] $white[2] --bold
    set -x color_vi_mode_visual           	$orange $white[2] --bold

    set -x color_vagrant                  	$purple $white[2] --bold
    set -x color_k8s                      	$green[2] $white[1] --bold
    set -x color_username                 	$grey[1] $blue[2] --bold
    set -x color_hostname                 	$grey[1] $blue[2]
    set -x color_rvm                      	$red[2] $white[2] --bold
    set -x color_virtualfish              	$blue[2] $white[2] --bold
    set -x color_virtualgo                	$blue[2] $white[2] --bold
end
