source ${HOME}/.customize/style.sh

get_workspace_name() {
    echo ${WORKSPACE_TOP##*/}
}

make_symbol() {
    if [[ "$WORKSPACE_TOP" = *"universe"* ]]; then
        echo "🛸"
    else
        echo "🥧"
    fi
}

GIT_BRANCH="(\$(__git_ps1 '%s'))"

STATION_NAME="$(cat /etc/hostname)"

HOST=$(echo $STATION_NAME | paint $RED | paint $BOLD)
GIT=$(echo $GIT_BRANCH | paint $BLUE | paint $BOLD)
DIR=$(echo "\W" | paint $CYAN | paint $BOLD)
WORKSPACE=$(echo "|\$(get_workspace_name)|" | paint $MAGENTA | paint $BOLD)
END=$(echo "\$" | paint $YELLOW | paint $BOLD)
SYMBOL="$(echo "\$(make_symbol)")"

PS1="$SYMBOL $HOST $GIT $WORKSPACE $DIR$END "

# PS1="$(echo -E "$PS1" | paint $BOLD)"
