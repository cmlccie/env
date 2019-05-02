echo "Loading: .bashrc"

if [[ $- == *i* ]]; then
    # Interactive Shell
    echo "Interactive Shell"

    ### Configure Shell
    HISTCONTROL=ignoreboth
    HISTSIZE=1000
    HISTFILESIZE=2000
    shopt -s histappend
    shopt -s checkwinsize
    shopt -s globstar


    # Enable color support
    export CLICOLOR=1
    export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
    if command -v dircolors 1>/dev/null 2>&1; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias la='ls -la --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'
    fi


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


    ### Shell Tools
    ## pyenv
    command -v pyenv 1>/dev/null 2>&1 && eval "`pyenv init -`"

    ## pew
    command -v pew 1>/dev/null 2>&1 && source $(pew shell_config)

    ## pip
    command -v pip 1>/dev/null 2>&1 && eval "`pip completion --bash`"
    command -v pip3 1>/dev/null 2>&1 && eval "`pip3 completion --bash`"

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

    ## direnv
    command -v direnv 1>/dev/null 2>&1 && eval "`direnv hook bash`"

    ## travis
    [[ -f ~/.travis/travis.sh ]] && source ~/.travis/travis.sh


    ### Aliases
    [[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
    alias swift='PATH="/usr/bin:$PATH" swift'


else
    # Non-Interactive Shell
    echo "Non-Interactive Shell"

    ## direnv
    command -v direnv 1>/dev/null 2>&1 && eval $(direnv export bash)

fi
