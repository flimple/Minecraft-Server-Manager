cd ../..
printf "The current directory is : ["
pwd
printf "]\n"
read -p "Enter target path [default: env/] [type cancel to cancel] : " tar_path
tar_path="${tar_path:-env/}"
if [ "$tar_path" = "cancel" ]; then
    echo "Canceling the setup procedure."
    exit 0
fi
if [ ! -d "$tar_path" ]; then
    mkdir -p "$tar_path"
fi
