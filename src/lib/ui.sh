#!/bin/bash
declare -i descriptions=1
if [ ! -d "data/" ]; then
    create_folder "data/"
    echo 0 > "data/ui_desc.dat"
elif [ ! -f "data/ui_desc.dat" ]; then
    echo 1 > "data/ui_desc.dat"
else
    descriptions=$(cat "data/ui_desc.dat")
fi
declare -r CONFIG_FILE="lib/server/nav_config.json"
toggle_desc() {
    descriptions=$(( ! descriptions ))
    echo "$descriptions" > "data/ui_desc.dat"
    return 0
}


display_app_title() {
    echo "┌────────────────────────────────────────────────────────┐"
    figlet -f slant "MINECRAFT"
    figlet -f small "Server Management"
    echo "└────────────────────────────────────────────────────────┘"
    return 0
}

open_box(){
    echo "┌────────────────────────────────────────────────────────┐"
    return 0
}

display_title() {
    local title="$1"
    title="${1:-MINECRAFT}"
    title="${1^^}"
    figlet -f slant "$title"
    return 0
}

display_sub_title(){
    local sub="$1"
    sub="${1:-Server Management}"
    figlet -f small "$sub"
    return 0
}

close_box() {
    echo "└────────────────────────────────────────────────────────┘"
    return 0
}

# Crucial variables
declare -i navigation_level=0
declare -i last_nav_level=0
declare -A nav_commands=( 
    ["refresh"]=continue
    ["exit"]=break 
    ["servers"]="change_nav_level 1" 
    ["backups"]="change_nav_level 2" 
    ["options"]="change_nav_level 3" 
    ["menu"]="change_nav_level 0" 
    ["back"]="go_back_nav_level" 
    ["desc"]=toggle_desc
)
declare -r nav_commands

analyze_input() {
    input="$1"
    echo "${nav_commands["$input"]}"
    return 0
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
        printf "$(jq -r --arg lvl "$navigation_level" --arg btn "$button" '.[$lvl].buttons.[$btn].display' "$CONFIG_FILE")"
        if (( descriptions )); then
            echo "---  $(jq -r --arg lvl "$navigation_level" --arg btn "$button" '.[$lvl].buttons.[$btn].description' "$CONFIG_FILE")"
        fi
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
    last_nav_level="$navigation_level"
    navigation_level="$new_level"
    return 0
}

go_back_nav_level() {
    local temp="$navigation_level"
    navigation_level="$last_nav_level"
    last_nav_level="$temp"
    return 0
}

launch_navigation() {
    # The first clear is for clearing the terminal completely before even starting the nav
    clear
    navigation_level=0
    
    local input=""

    while true; do
        display_current_level
        read -p "Please enter a command [default : refresh] : " input
        input="${input:-refresh}"
        clear
        command=$(analyze_input "$input")
        $command
    done
    return 0
}