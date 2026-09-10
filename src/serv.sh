#!/bin/bash
source lib/init.sh

# State saving control (Saved for later)
SERVERS_STATE_FILE='/dev/shm/mc_server_states/global.dat'
SERVERS_LOCAL_DATA='/data/'
SERVERS_CREATED_FILE='/data/servers.dat'

# Argument control

folder_exists "/dev/shm/server_states/"
folder_exists "$SERVERS_LOCAL_DATA"
file_exists "$SERVERS_CREATED_FILE"
file_exists "$SERVERS_STATE_FILE"
create_folder "$SERVERS_LOCAL_DATA"
create_file ""$SERVERS_CREATED_FILE