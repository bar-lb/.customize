REMOTE_A_NAME="build01"
REMOTE_A_COLOR="'#01242D'"

REMOTE_B_NAME="build02"
REMOTE_B_COLOR="'#02250B'"

REMOTE_C_NAME="build03"
REMOTE_C_COLOR="'#2D0701'"

STATION_NAME="$(cat /etc/hostname)"

if [[ "${STATION_NAME}" = *"${REMOTE_A_NAME}"* ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color $REMOTE_A_COLOR
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors "false"
elif [[ "${STATION_NAME}" = *"${REMOTE_B_NAME}"* ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color $REMOTE_B_COLOR
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors "false"
elif [[ "${STATION_NAME}" = *"${REMOTE_C_NAME}"* ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color $REMOTE_C_COLOR
    dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors "false"
fi

