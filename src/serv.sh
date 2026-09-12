#!/bin/bash
source lib/init.sh

# State saving control (Saved for later)
SERVERS_STATE_FILE='/dev/shm/mc_server_states/global.dat'
SERVERS_LOCAL_DATA='data/'
SERVERS_CREATED_FILE='data/servers.dat'
if ! file_exists "$SERVERS_CREATED_FILE"; then
    create_folder "$SERVERS_LOCAL_DATA"
    create_file "$SERVERS_CREATED_FILE"
    # Added so that the init will be clean without any interruptions
    echo "Init"
    exit 0
fi

# Argument management
arg1="${1:-false}"
arg2="${2:-false}"
arg3="${3:-false}"

# Setup logic
if [ "$arg1" = "setup" ]; then
    cd lib
    ./stp.sh
    exit 0
fi

# Checking the setup and config have already been run.
if [ ! -d "data/" ]; then
    echo "The app data folder was not found. Please reinstall."
    exit 1
elif [ ! -f "data/config.json" ]; then
    echo "The app config was not found. Please reinstall."
    exit 1
else
    # If the path or file does exit, we check the contents.
    if ! [ "$(jq -r '.setup' "data/config.json")" = "true" ]; then
        printf "There seems to be an issue with the config.\nRunning the setup is suggested.\n"
        exit 1
    fi
fi

# Ui or quick commands exectuion check.
if [ "$arg1" = "false" ]; then
    # The app will take control of the terminal and how it looks
    clear
    echo "Initializing the MSM view interface."
    sleep 1
    display_menu
    exit 0
else
    echo "Argument oriented process."
    exit 0
fi