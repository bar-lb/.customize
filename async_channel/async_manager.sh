__CHANNEL_DIR="${HOME}/.customize/async_channel"

run_async() {
    CMD=${@:2}
    CHAN="${__CHANNEL_DIR}/$1"
    
    echo "DEBUG $CMD"
    echo "DEBUG $CHAN"

    ($CMD) > $CHAN &
}

async_result() {
    cat ${__CHANNEL_DIR}/$1
}

run_async_result() {
    run_async ${@} &&
    async_result "$1" # 2> /dev/null
}
