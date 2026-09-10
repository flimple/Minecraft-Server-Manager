folder_exists() {
    if [ "$#" -eq 0 ]; then
        echo "Error : arguments insufficient"
        exit 1
    fi
    [ -d "$1" ] && echo "true" || echo "false"
}

file_exists() {
    if [ ! -z "$1" ]; then
        [ -f "$1" ] && echo "true" || echo "false"
    fi
}