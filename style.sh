RED=91
GREEN=92
YELLOW=93
BLUE=94
MAGENTA=95
CYAN=96
WHITE=97
BLACK=30
COLOR_RESET=39

BOLD=1
UNDERLINE=4
FORMAT_RESET=0


FINISH="\]"
START="\["

_wrapup(){
    echo -E "$START$1$FINISH"
}

reset_style(){
    _wrapup "\e[${FORMAT_RESET}m"
}

bashstyle(){
    _wrapup "\e[$1m"
}

paint(){
    read -r TEXT
    COLOR=$(_wrapup "\e[$1m")
    RESET=$(_wrapup "\e[${FORMAT_RESET}m")
    echo -E "$COLOR$TEXT$RESET"
}

paintrnd() {
    MIN=$1
    LEN=$2
    read -r TEXT
    RND=$(( ( RANDOM % $LEN )  + $MIN ))
    COLOR=$(_wrapup "\e[38;5;${RND}m")
    RESET=$(_wrapup "\e[${FORMAT_RESET}m")
    echo -E "$COLOR$TEXT$RESET"
}
