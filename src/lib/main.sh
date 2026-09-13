vanilla_link() {
    return 0
}


create_server() {
    # Variables detection
    name="${1:-A Minecraft Server}"
    version="${2:-26.2}"
    id="$3"
    loader="${4:-vanilla}"
    loader_version="$5"

    return 0
}