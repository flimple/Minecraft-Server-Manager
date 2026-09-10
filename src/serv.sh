#!/bin/bash
source lib/init.sh

# State saving control (Saved for later)
SERVERS_STATE_FILE='/dev/shm/mc_server_states/global.dat'
SERVERS_LOCAL_DATA='data/'
SERVERS_CREATED_FILE='data/servers.dat'
if ! file_exists "$SERVERS_CREATED_FILE"; then
    create_folder "$SERVERS_LOCAL_DATA"
    create_file "$SERVERS_CREATED_FILE"
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