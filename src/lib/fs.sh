folder_exists() {
    if [ ! -z "$1" ]; then
        [ -d "$1" ] && echo "true" || echo "false"
    else
        echo "Enter a valid path to a directory."
        exit 1
    fi
}

file_exists() {
    if [ ! -z "$1" ]; then
        [ -f "$1" ] && echo "true" || echo "false"
    else
        echo "Enter a valid path to a file."
        exit 1
    fi
}