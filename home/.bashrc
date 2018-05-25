echo "Loading: .bashrc"

if [[ $- == *i* ]]; then
    # Interactive Shell
    echo "Interactive Shell"


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
    export PS1="\[\e[34m\]\W\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\] \[\e[34m\]\\$\[\e[m\] "


    ### Shell Tools
    ## pyenv
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi

    ## pew
    source $(pew shell_config)


    ### Shell Completions
    ## brew
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    ## pip
    # pip completion --bash
    _pip_completion()
    {
        COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                    COMP_CWORD=$COMP_CWORD \
                    PIP_AUTO_COMPLETE=1 $1 ) )
    }
    complete -o default -F _pip_completion pip
    complete -o default -F _pip_completion pip2
    complete -o default -F _pip_completion pip3

    ## pipenv
    # pipenv --completion
    _pipenv_completion() {
        local IFS=$'\t'
        COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                    COMP_CWORD=$COMP_CWORD \
                    _PIPENV_COMPLETE=complete-bash $1 ) )
        return 0
    }
    complete -F _pipenv_completion -o default pipenv

    ## google-cloud-sdk
    source ~/dev/tools/google-cloud-sdk/completion.bash.inc


    ### Interactive Environment Variable Management
    ## direnv
    eval "$(direnv hook bash)"


else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ### Non-Interactive Environment Variable Management
    ## direnv
    eval "$(direnv export bash)"


fi
