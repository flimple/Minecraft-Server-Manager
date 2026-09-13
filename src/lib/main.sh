load_vanilla_versions() { 
    return 0
}

check_van_version() {
    mapfile -t vanilla_versions < <(jq -r ".versions[]" "lib/servers/types/vanilla_versions.json")
    return 0
}