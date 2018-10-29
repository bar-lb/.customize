source ${HOME}/.customize/style.sh

GIT_BRANCH="(\$(__git_ps1 '%s'))"

LB=$(echo "(\$(cat ${HOME}/.lbprompt))" | paint $RED | paint $BOLD)
GIT=$(echo $GIT_BRANCH | paint $BLUE | paint $BOLD)
DIR=$(echo "\W" | paint $CYAN | paint $BOLD)
END=$(echo "\$" | paint $YELLOW | paint $BOLD)

STATION_NAME="$(cat /etc/hostname)"

if [[ "${STATION_NAME}" = *"build"* ]]; then
    STATION="📡"
else
    STATION="💻"
fi

PS1="$STATION $LB $GIT $DIR$END "

# PS1="$(echo -E "$PS1" | paint $BOLD)"
