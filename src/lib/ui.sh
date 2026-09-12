#!/bin/bash

display_top() {
    echo "┌────────────────────────────────────────────────────────┐"
    figlet -f slant "MINECRAFT"
    figlet -f small "Server Management"
    echo "└────────────────────────────────────────────────────────┘"
    return 0
}

display_server_display() {
    return 0
}

display_menu_commands() {
    return 0
}

declare -A nav_commands
declare -i navigation_level=0
analyze_input() {
    local input="$1"
    echo "${nav_commands["$input"]}"
}



launch_navigation() {
    # The first clear is for clearing the terminal completely before even starting the nav
    clear

    # Imo having the dict of nav commands be loaded only after the navigation is called is better
    navigation_level=0
    nav_commands=( ["refresh"]=continue ["exit"]=cancel )
    declare -r nav_commands
    local input=""

    while true; do
        display_top
        read -p "Please enter a command [default : refresh] : " input
        input="${input:-refresh}"
        clear
        command=$(analyze_input "$input")
        $command
    done
}