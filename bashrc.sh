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
WORKSPACE_DEFAULT="workspace"
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

source ${HOME}/.customize/enviro.sh
source ${HOME}/.customize/PS1.sh

#############################################

################## Shortcuts! ###############

source ${HOME}/.customize/async_channel/async_manager.sh

#don't use those who start with '__'

INFINITY=999999999

ctags_def() {
    ctags -R ${WORKSPACE_TOP}/kernelight/
    ctags -R ${WORKSPACE_TOP}/usrlight/
    ctags -R ${WORKSPACE_TOP}/duroslight/
    ctags -R ${WORKSPACE_TOP}/management/
    ctags -R ${WORKSPACE_TOP}/systests/
    ctags -R ${WORKSPACE_TOP}/testOSterone/
    ctags -R ${WORKSPACE_TOP}/common/
}

alias drpt="dockerize run_test.sh --pylint --timeout $INFINITY"
alias dr="drpt --debug"
alias dm="dockerize make"
alias dmm="dm clean-all docker-build" # for compiling management code
alias dmmm="jpm && dmm && jps"
alias dmu="dm -f Makefile.lb clean build install" # for compiling usrlight code
alias agn="ag --ignore-dir racktests/ --ignore-dir tests/ --ignore-dir test_logs/"
alias lbctags="ctags_def"

count_allocated_machines() {
   dockerize python3 ${WORKSPACE_TOP}/testOSterone/testos/racktest/allocation_manager.py -o minimal
}

alias alcount="count_allocated_machines"

rfs(){ # build and checkin rootfs
    CAME_FROM=$PWD
    cd ${WORKSPACE_TOP}/rootfs
#    sudo rm -rf $WORKSPACE_TOP/build || echo "FAILED TO DELETE OLD BUILDS!";
    (dockerize make clean $1 || (echo -e "ROOTFS BUILD FAILED! $1" | paint $RED | paint $BOLD)) && \
    (dockerize make checkin_$1 || (echo -e "ROOTFS CHECKIN FAILED $1" | paint $RED | paint $UNDERLINE));
    cd ${CAME_FROM}
}

alias rfsp="rfs rootfs_product_centos"
alias rfsb="rfs rootfs_product_base_centos"
alias rfsh="rfs rootfs_host_basic"
alias rfsall="rfsp && rfsh"

kernmake(){ # build relevant rootfses for running kernelight tests
    rfs rootfs_product_base$testOS
}


sysmake(){ # build relevant rootfses for running system tests
    rfs rootfs_product$testOS
    rfs rootfs_host_basic
}

setup_breakpoint() {
    CURRLOC=$PWD
    cd ${WORKSPACE_TOP}/testOSterone && \
    git cherry-pick origin/bar/__bp__
    cd $CURRLOC
}

alias bp="setup_breakpoint"

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

gitget(){
    echo $(__git_ps1 | tr -d '()' | cut -c 2-)
}

alias gitch="git checkout"
alias gitpushme="git push -f origin HEAD:$(gitget)"
alias gits="git status"
alias gitl="git log"
alias gitb="git branch"
alias gitp="gitpushme"

gitpushpart(){
    PARENT=$1
    THIS_BRANCH=$(gitget)
    $("gitch HEAD~{$PARENT}")
    gitpushme
    gitch $THIS_BRANCH
}

alias gitpp="gitpushpart"

_makesure(){
 	echo "sure?"
	read $ANS
	if [ "$ANS" = "yes\n" ];
	then
		return 0
	fi
	
	return 1
}

getrfs(){
    dockerize component-tool label --repo=rootfs rootfs_product_centos
}

_drstatic_check() {
    if ! cat $1 | grep "install_mgmt_stack" &> /dev/null ; then
        echo -e "You need to call method 'install_mgmt_stack()' in your test."
        return 1
    fi
    return 0
}

drstatic(){
    # provide a specific rootfs to run. include only its hash as the first parameter of this cmd.
    # currently working only with rootfs_product_centos
    HASH=$1
    TEST_FILE=$2
    _drstatic_check $TEST_FILE && \
    ROOTFS_PRODUCT_CENTOS=${HASH}__rootfs_product_centos__${BUILD_TYPE} time dockerize run_test.sh ${TEST_FILE} --debug --pylint
}

dralloc() {
    # choose an allocator to run on
    ALLOCATOR_URI="$URI:$1"
    drpt $2
}

gitprune(){
    #remove all local branches
	_makesure && git branch | grep -v "master" | xargs git branch -D

}

gitfresh(){ #remove given branch, replace it with its remote version
	BRANCH=$1
	_makesure && \
	git checkout origin/$BRANCH && \
	git branch -D $BRANCH && \
	git checkout -b $BRANCH
}

_complete_project_name(){
    REPOS=( "kernelight" "usrlight" "testOSterone" "common" "management" "systests" "rootfs" "duroslight" "lightbits-api" "light-app" )

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

_list_all_rootfs(){
    ls ${WORKSPACE_TOP}/rootfs | grep "rootfs_"
}

_complete_rootfs_name(){
    ROOTFSES=($(_list_all_rootfs))

    COMPREPLY=()

    CUR=${COMP_WORDS[COMP_CWORD]}
    for i in "${ROOTFSES[@]}"
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

where_have_i_crashed() {
    KOFILE=$1
    LOCATION=$2
    eu-addr2line -e ${KOFILE} -j .code ${LOCATION}
}

alias whic="where_have_i_crashed"

complete -F _complete_project_name jp

complete -F _complete_rootfs_name rfs

alias jpk="jp kernelight"
alias jps="jp systests"
alias jpu="jp usrlight"
alias jpm="jp management"
alias jpt="jp testOSterone"
alias jpr="jp rootfs"
alias jpc="jp common"
alias jpd="jp duroslight"
alias jpapi="jp lightbits-api"
alias jpla="jp light-app"
alias flee="cd ~/PersonalStuff"

switchwork() {
    OLD_WORKSPACE="${WORKSPACE_TOP}"
    WORKSPACE_NEW="${HOME}/$1"
    LOC=$(pwd)
    NEW_LOC=$(echo $LOC | sed -e "s:${OLD_WORKSPACE}:${WORKSPACE_NEW}:g")
    cd $NEW_LOC &&
    source ${WORKSPACE_NEW}/.env && echo "welcome to ${WORKSPACE_NEW}"
}

alias xw="switchwork workspace"
alias xu="switchwork workuniverse"
alias xd="switchwork durospace"

alias jpmd="xd && jpm"
alias jpdd="xd && jpd"

diskfull() { # clean your workspace to free storage
    _makesure && \
    echo "Deleting, be patient...." && \
    sudo rm -rf $WORKSPACE_TOP/build && \
    sudo rm -rf /var/lib/osmosis/* && \
    echo "Done!"
}

newproject() {
    TICKET=$1
    BRANCH="${USER}/$2"
    ALTBRANCH="${USER}/issue_of_$2"
 
    git fetch
    git checkout -b ${ALTBRANCH} origin/master
    git checkout "issue_stack" || git checkout -b "issue_stack" origin/master
    git cherry_pick ${ALTBRANCH} || echo "FAILED TO ADD TO STACK!"
    git checkout ${ALTBRANCH}
    git commit -m "Issue: ${TICKET}" --allow-empty
    git checkout -b ${BRANCH} origin/master
}

alertdone() {
    read MSG
    notify-send "Command Done!" "$MSG"
}

alias alertd="alertdone"
alias ad="alertdone"

#go to default workspace

switchwork ${WORKSPACE_DEFAULT}

# Enter to tmux when opening terminal
[ -z "$TMUX" ] && (tmux attach -t workplace || tmux new -s workplace)

