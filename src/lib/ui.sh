#!/bin/bash

display_top() {
    echo "┌────────────────────────────────────────────────────────┐"
    figlet -f slant "MINECRAFT"
    figlet -f small "Server Management"
    echo "└────────────────────────────────────────────────────────┘"
    sleep 1
    return 0
}

display_server_display() {
    return 0
}





launch_navigation() {
    while true; do
        display_top
        read -p "Please enter a command [default : refresh] : " input
        input="${input:-refresh}"
        clear
        if [[ $input == "refresh" ]]; then
            continue
        fi

        if [[ $input == "exit" ]]; then
            break
        fi
    done
}