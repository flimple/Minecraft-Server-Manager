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

declare -r NAV_CONFIG_FILE="lib/server/nav_config.json"
declare -r CR_CONFIG_FILE="lib/server/server_creation_config.json"

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

declare -i navigation_level=0
declare -i last_nav_level=0

go_back_nav_level() {
    local temp="$navigation_level"
    navigation_level="$last_nav_level"
    last_nav_level="$temp"
    return 0
}

display_server_creation() {
    clear
    last_nav_level="$navigation_level"
    navigation_level="-1"
    declare -i cr_data_fill_level=-1
    mapfile -t fill_data_keys < <(jq -r  'keys_unsorted[]' "$CR_CONFIG_FILE")
    declare -i -r max_cr_data_fill_level="${#fill_data_keys[@]}"
    filled_data=()
    
    while true; do
        display_title "Servers Management"
        display_sub_title "Create a server"
        open_box
        for (( i=0; i<max_cr_data_fill_level; i++ )); do
            printf "$(jq -r --arg key "${fill_data_keys[i]}" '.[$key].display' "$CR_CONFIG_FILE" )"
            if (( i <= cr_data_fill_level )); then
                printf "${filled_data[i]}"  
            fi
            printf "\n"
        done
        close_box
        prompt=""
        if (( cr_data_fill_level + 1 == max_cr_data_fill_level )); then
            # We filled all data required
            read -p "Please review the entered information and confirm the creation of the server (y/n) [default: no] : " confirmation_cr
            confirmation_cr="${confirmation_cr:-n}"
            confirmation_cr="${confirmation_cr,,}"
            # If the user cancels the creation
            if [ "$confirmation_cr" != "y" ]; then
                clear
                echo "Server creation canceled. Returning.."
                sleep 1
                go_back_nav_level
                last_nav_level=0
                return 0
            fi
            # If the user accepts the creation
            # Server creation logic should link up with the main.sh
            # Relocating to menu
            echo "Server creation logic not found. Canceling.."
            sleep 1
            go_back_nav_level
            last_nav_level=0
            return 0
        else
            # Some data remain, fetch prompt
            prompt=$(jq -r --arg key "${fill_data_keys[cr_data_fill_level+1]}" '.[$key].prompt // "Press enter to continue."' "$CR_CONFIG_FILE")
        fi
        read -p "" cr_input
        cr_input="${cr_input:-refresh}"
        [ "$cr_input" = "refresh" ] && continue

        # The clear is placed here so that the bugs or errors appear on the top of the ui
        clear
        filled_data+=("$cr_input")
        [ "$cr_input" != "refresh" ] && (( cr_data_fill_level++ ))
        
    done
    
    return 0
}

# Crucial variables
declare -A nav_commands=( 
    ["refresh"]=continue
    ["exit"]=break 
    ["servers"]="change_nav_level 1" 
    ["backups"]="change_nav_level 2" 
    ["options"]="change_nav_level 3" 
    ["menu"]="change_nav_level 0" 
    ["back"]="go_back_nav_level" 
    ["descriptions"]=toggle_desc 
    ["create"]=display_server_creation 
)
declare -r nav_commands

analyze_input() {
    input="$1"
    echo "${nav_commands["$input"]}"
    return 0
}

# Needs to be below the nav_level var
display_current_level() {
    if (( navigation_level < 0 )); then
        # Means we're in a controlled access tab
        return 0
    fi
    # Preload actions
    mapfile -t pre_load_actions < <(jq -r --arg lvl "$navigation_level" '.[$lvl].button_pre_load_actions[]' "$NAV_CONFIG_FILE")
    for action in "${pre_load_actions[@]}"; do
        $action
    done

    # Buttons display
    mapfile -t buttons < <(jq -r --arg lvl "$navigation_level" '.[$lvl].buttons | keys_unsorted[]' "$NAV_CONFIG_FILE")
    for button in "${buttons[@]}"; do
        printf "$(jq -r --arg lvl "$navigation_level" --arg btn "$button" '.[$lvl].buttons.[$btn].display' "$NAV_CONFIG_FILE")"
        if (( descriptions )); then
            echo "  -->  $(jq -r --arg lvl "$navigation_level" --arg btn "$button" '.[$lvl].buttons.[$btn].description' "$NAV_CONFIG_FILE")"
        else
            printf "\n"
        fi
    done

    # Postload actions
    mapfile -t post_load_actions < <(jq -r --arg lvl "$navigation_level" '.[$lvl].button_post_load_actions[]' "$NAV_CONFIG_FILE")
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