# echo "Loading: .bashrc"

if [[ $- == *i* ]]; then
    # Interactive Shell
    # echo "Interactive Shell"

    # Enable color support
    export CLICOLOR=1
    export LSCOLORS="exfxcxdxbxegedabagacad"
    export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"


    ### Initialize Interactive Prompt
    # http://ezprompt.net/
    # get current branch in git repo
    function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
            STAT=`parse_git_dirty`
            echo "[${BRANCH}${STAT}]"
        else
            echo ""
        fi
    }
    # get current status of git repo
    function parse_git_dirty {
        status=`git status 2>&1 | tee`
        dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
        deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
        bits=''
        if [ "${renamed}" == "0" ]; then
            bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
            bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
            bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
            bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
            bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
            bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
            echo " ${bits}"
        else
            echo ""
        fi
    }
    PS1="\[\e[34m\]\W\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\] \[\e[34m\]\\$\[\e[m\] "


    ### Tool Configuration
    # pew
    if command -v pew 1>/dev/null 2>&1; then
        source $(pew shell_config)
    fi

    # direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv hook bash)"
    fi

    # isengardcli
    if command -v isengardcli 1>/dev/null 2>&1; then
        eval "$(isengardcli shell-profile --keep-prompt)"
    fi

    # iTerm2
    if [[ -e ${HOME}/.iterm2_shell_integration.bash ]]; then
        source ${HOME}/.iterm2_shell_integration.bash
    fi

    # travis
    if [[ -e ${HOME}/.travis/travis.sh ]]; then
        source ${HOME}/.travis/travis.sh
    fi


    ### Bash Aliases
    if [[ -e ${HOME}/.aliases.bash ]]; then
        source ${HOME}/.aliases.bash
    fi


else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    if command -v direnv 1>/dev/null 2>&1; then
        eval "$(direnv export bash)"
    fi

fi
