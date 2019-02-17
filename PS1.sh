source ${HOME}/.customize/style.sh

GIT_BRANCH="(\$(__git_ps1 '%s'))"

STATION_NAME="$(cat /etc/hostname)"

HOST=$(echo $STATION_NAME | paint $RED | paint $BOLD)
GIT=$(echo $GIT_BRANCH | paint $BLUE | paint $BOLD)
DIR=$(echo "\W" | paint $CYAN | paint $BOLD)
END=$(echo "\$" | paint $YELLOW | paint $BOLD)

if [[ "${STATION_NAME}" = *"build"* ]]; then
    STATION="📡"
else
    STATION="💻"
fi

PS1="$STATION $HOST $GIT $DIR$END "

# PS1="$(echo -E "$PS1" | paint $BOLD)"
