#!/bin/bash
descriptions="false"
if [ ! -d "data/" ]; then
    create_folder "data/"
    echo "false" > "data/ui_desc.dat"
elif [ ! -f "data/ui_desc.dat" ]; then
    echo "false" > "data/ui_desc.dat"
else
    descriptions=$(cat "data/ui_desc.dat")
fi
declare -r CONFIG_FILE="lib/server/nav_config.json"

display_title() {
    echo "┌────────────────────────────────────────────────────────┐"
    figlet -f slant "MINECRAFT"
    figlet -f small "Server Management"
    echo "└────────────────────────────────────────────────────────┘"
    return 0
}


declare -A nav_commands
declare -i navigation_level=0
analyze_input() {
    local input="${1,,}"
    echo "${nav_commands["$input"]}"
}

# Needs to be below the nav_level var
display_current_level() {
    # Preload actions
    mapfile -t pre_load_actions < <(jq -r --arg lvl "$navigation_level" '.[$lvl].button_pre_load_actions[]' "$CONFIG_FILE")
    for action in "${pre_load_actions[@]}"; do
        $action
    done

    # Buttons display
    mapfile -t buttons < <(jq -r --arg lvl "$navigation_level" '.[$lvl].buttons | keys_unsorted[]' "$CONFIG_FILE")
    for button in "${buttons[@]}"; do
        echo "$(jq -r --arg lvl "$navigation_level" --arg btn "$button" '.[$lvl].buttons.[$btn].display' "$CONFIG_FILE")"    
    done

    # Postload actions
    mapfile -t post_load_actions < <(jq -r --arg lvl "$navigation_level" '.[$lvl].button_post_load_actions[]' "$CONFIG_FILE")
    for action in "${post_load_actions[@]}"; do
        $action
    done
    return 0
}

change_nav_level() {
    local new_level="$1"
    return 0
}

launch_navigation() {
    # The first clear is for clearing the terminal completely before even starting the nav
    clear

    # Imo having the dict of nav commands be loaded only after the navigation is called is better
    navigation_level=0
    nav_commands=( ["refresh"]="continue" ["exit"]=break ["servers"]="change_level 1" ["backups"]="change_level 2" ["options"]="change_level 3" ["menu"]="change_level 0" )
    declare -r nav_commands
    local input=""

    while true; do
        display_current_level
        read -p "Please enter a command [default : refresh] : " input
        input="${input:-refresh}"
        # clear
        echo "$input"
        sleep 2
        command=$(analyze_input "$input")
        echo "$command"
        $command
        sleep 2
    done
    return 0
}