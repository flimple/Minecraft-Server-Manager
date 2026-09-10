#!/bin/bash
source lib/init.sh

# State saving control (Saved for later)
SERVERS_STATE_FILE='/dev/shm/mc_server_states/global.dat'
SERVERS_CREATED_FILE='/data/servers.dat'

# Argument control

folder_exists "/dev/shm/server_states/"
file_exists "$SERVERS_CREATED_FILE"
file_exists "$SERVERS_STATE_FILE"