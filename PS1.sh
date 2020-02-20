source ${HOME}/.customize/style.sh

#----------- few colors-sets -----------
# -- set the desired one in COLOR_MIN --
PINKISH=196
GREENISH=106
PURPULISH=124
YELLOWISH=214
#--------------------------------------

COLOR_MIN=$PINKISH
COLOR_LEN=12

get_workspace_name() {
    echo ${WORKSPACE_TOP##*/}
}

make_symbol() {
    if [[ "$WORKSPACE_TOP" = *"universe"* ]]; then
        echo "🛸"
    elif [[ "$WORKSPACE_TOP" = *"duros"* ]]; then
        echo "🚧"
    else
        echo "🥧"
    fi
}

GIT_BRANCH="(\$(__git_ps1 '%s'))"

STATION_NAME="$(cat /etc/hostname)"

HOST=$(echo $STATION_NAME | paintrnd $COLOR_MIN $COLOR_LEN | paint $BOLD)
GIT=$(echo $GIT_BRANCH | paintrnd $COLOR_MIN $COLOR_LEN | paint $BOLD)
DIR=$(echo "\W" | paintrnd $COLOR_MIN $COLOR_LEN | paint $BOLD)
WORKSPACE=$(echo "|\$(get_workspace_name)|" | paintrnd $COLOR_MIN $COLOR_LEN | paint $BOLD)
END=$(echo "\$" | paintrnd $COLOR_MIN $COLOR_LEN | paint $BOLD)
SYMBOL="$(echo "\$(make_symbol)")"
ALLOCS="?" #"$(echo "\$(alcount)")"

PS1="$SYMBOL $HOST $GIT $WORKSPACE $ALLOCS $DIR$END "

# PS1="$(echo -E "$PS1" | paint $BOLD)"
