cd ../..
setup_path=$(pwd)
printf "The current directory is : $setup_path\n"
read -p "Enter target path [default: env/] [type cancel to cancel] : " tar_path
tar_path="${tar_path:-env/}"
if [ "$tar_path" = "cancel" ]; then
    echo "Canceling the setup procedure."
    exit 0
fi
if [ ! -d "$tar_path" ]; then
    mkdir -p "$tar_path"
fi

shopt -s nullglob
items=("$tar_path"*)
count="${#items[@]}"
shopt -u nullglob
if [ "$count" != "0" ]; then
    read -p "The directory you provided is not empty, the script will proceed to update the necessary files and folders accordingly (y/n) [default : no] : " update_choice
    update_choice="${update_choice:-n}"
    # To lower
    update_choice="${update_choice,,}"
    if [ "$update_choice" = "n" ]; then
        echo "Cannot proceed without confirmation or access to the files inside target directory."
        exit 1
    fi
    echo "The existing directories will be updated accordingly."
fi

# Fetching the config
CONFIG_FILE='src/lib/server/servers_config.json'
server_types=$(jq -r 'keys[]' "$CONFIG_FILE")
cd "$tar_path"

# Main dirs init
main_dirs=("backups" "servers" "temp" "data")
for fd in "${main_dirs[@]}"; do
    [ ! -d "$fd" ] && mkdir "$fd"
done

# Server types init

cd "servers"
for fd in $server_types; do
    [ ! -d "$fd" ] && mkdir "$fd"
done

# Generating a file in the data folder to confirm the setup has been run.
cd "$setup_path"
cd "src/data/"
touch "config.json"
jq -n '{version: "0.0.1", setup: "true"}' > config.json

echo "The setup was successfully completed."
read -p "Do you wish to open the --Minecraft Servers Manager-- now ? (y/n) [default is no] : " open_confirmation
open_confirmation="${open_confirmation:-n}"
open_confirmation="${open_confirmation,,}"
if [ "$open_confirmation" = "n" ]; then
    echo "Exiting the -MSM- setup."
    exit 0
fi

echo "Opening the --Minecraft Servers Manager--.."
cd ..
./serv.sh