# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


####### Lightbits Specifics ########

WORKSPACE_TOP="${HOME}/workspace"

# automaticaly enter workspace
if [[ $PWD != "${WORKSPACE_TOP}"* ]]; then
  cd $WORKSPACE_TOP
fi

# for the use of testos_cli
LABGW="http://labgw:22222"

source ${WORKSPACE_TOP}/.env

# use rel by default
export BUILD_TYPE=rel

# currently MUST be set to '_centos'!
# for ubuntu uncomment the line below
export testOS="_centos"
#export testOS=""

# simple connection to VPN
vpnf(){
    $HOME/vpnf $1
}

###### end: Lightbits Specifics #####


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


if [[ -n ${TMUX} ]]; then
  export TERM="screen-256color"
else
  export TERM="xterm-256color"
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


######## 'twenty-four shades of Bash' ############
###### the terminal styling factory! ########

source ${HOME}/.customize/PS1.sh

#############################################

################## Shortcuts! ###############


#don't use those who start with '__'


cdd(){ # goto project
	cd ~/workspace/$1
}

dr(){ #Shortcuts for "dockerize run_test.sh"
    retries=${2:-1}
    for ((number=0;number < $retries;number++))
	{
	    number_of_times_human=$(($number + 1))
		echo "This is the $number_of_times_human time";
    	dockerize run_test.sh "$1" --debug --pylint
    }
}

rfsbuild(){ # build and checkin rootfs
    CAME_FROM=$PWD
    cd ${WORKSPACE_TOP}/rootfs
    dockerize make $1 || (banner "ROOTFS BUILD FAILED"; echo "rootfs: $1")
    dockerize make checkin_$1 || (banner "ROOTFS CHECKIN FAILED"; echo "rootfs: $1")
    cd ${CAME_FROM}
}

kernmake(){ # build relevant rootfses for running kernelight tests
    rfsbuild rootfs_product_base$testOS
}


sysmake(){ # build relevant rootfses for running system tests
    rfsbuild rootfs_product$testOS
    rfsbuild rootfs_host_basic
}


sysupload(){ # solves the 'no files to upload' problem on systests
        CURRLOC=$PWD
        cd ~/workspace/kernelight && \
        dockerize make -f Makefile && \
        cd ../kernel-headers/ && dockerize make booking && \
        cd ../nvme-host/ && dockerize make -f Makefile.lb all
        cd $CURRLOC
}

sync01(){ # *experimental* create a shared folder betweem local comp and build01
    scp /home/$USER/.bashrc bar@build01:/users1/$USER/.bashrc    
    scp -r /home/$USER/sync01_files bar@build01:/users1/$USER/
}

gitch(){
    git checkout $1
}

gitchb(){
    git checkout -b $1
}

gitpushme(){
    git push -f origin HEAD:$(__git_ps1 | tr -d '()' | cut -c 2-)
}

gits(){
    git status
}
gitl(){
    git log
}

gitbr(){
    git branch
}

_complete_project_name(){
    REPOS=( "kernelight" "usrlight" "testOSterone" "common" "management" "systests")

    COMPREPLY=()

    CUR=${COMP_WORDS[COMP_CWORD]}
    for i in "${REPOS[@]}"
    do
       :
       if [[ $i == "$CUR"* ]]; then
           COMPREPLY+=($i)
       fi
    done

    return 0
}

jp(){
    cd ${WORKSPACE_TOP}/$1
}

cdw(){
    jp $1
}

complete -F _complete_project_name jp
complete -F _complete_project_name cdw

prcheck_kernelight(){
	echo "make sure that this is the correct list of test from CI!" | paint $YELLOW
	sleep 5
	jp kernelight && \
	dockerize run_test.sh \
		--pylint --reporter_name xml_reporter --tag_name=sanity \
		--retries_allocation_failures 4 \
		--parallel 8 racktests/*.py ${USRLIGHT_RACKTEST}/{01,02,03,04,05,17,23,30}_*
}
