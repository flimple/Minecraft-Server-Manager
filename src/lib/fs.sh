folder_exists() {
    if [ -z "$1" ]; then
        echo "Enter a valid folder path."
        return 1
    fi
    [ -d "$1" ]
}

file_exists() {
    if [ -z "$1" ]; then
        echo "Enter a valid file path."
        return 1
    fi
    [ -f "$1" ]
}

create_file() {
    if [ -n "$1" ]; then
        if ! file_exists "$1"; then
            contents="${2:-false}"
            if [ "$contents" == "false" ]; then
                touch "$1"
                return 0
            else
                echo "$contents" > "$1"
                return 0
            fi
        else
            echo "This file ($1) already exists."
            return 1
        fi
    else
        echo "Enter a path to file."
        return 1
    fi
}

create_folder() {
    if [ -n "$1" ]; then
        if ! folder_exists "$1"; then
            mkdir -p "$1"
            return 0
        else
            echo "This folder path ($1) already exists."
            return 1
        fi
    else
        echo "Enter a folder path."
        return 1
    fi
}

delete_file() {
    if [ -n "$1" ]; then
        if file_exists "$1"; then
            rm -f "$1"
            return 0
        else
            echo "This file path ($1) doesn't exist."
            return 1
        fi
    else
        echo "Enter a file path."
        return 1
    fi
}

delete_folder() {
    if [ -n "$1" ]; then
        if folder_exists "$1"; then
            rm -rf "$1"
            return 0
        else
            echo "This folder path ($1) doesn't exist."
            return 1
        fi
    else
        echo "Enter a folder path."
        return 1
    fi
}