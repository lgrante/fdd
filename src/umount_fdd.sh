#!/usr/bin/bash


bold=$(tput bold);
normal=$(tput sgr0);
italic="\e[3m";
blue="\e[36m";
red="\e[31m";
no_color="\e[0m";

disk_name=$1;

print_help() {
    echo -e "${bold}USAGE${normal}\n\n";
    echo "fdd eject [DISK_NAME]";
    echo -e "fdd eject (--help | -h)\n";
    exit;
}

delete_symlink_file() {
    if ! test -f "./.mounted_disks"; then
	return;
    fi

    symlink_path=$(cat .mounted_disks | grep -e $disk_name | awk '{ print $2 }');
    if sudo rm -rf $symlink_path &> /dev/null; then
        echo -e "${blue}${italic} - ${symlink_path} symbolic link is deleted.${normal}";
    else
        echo -e "${red}${italic} - Failed to delete symbolic link ${symlink_path}.${normal}";
    fi
}


lfdd_output=$(lsblk -l | awk '$6 ~ /disk/ {getline;} $6 ~ /part/ {print;}');

echo -ne "\n";


if [ "$disk_name" = "" ] || [ "$disk_name" = "--help" ] || [ "$disk_name" = "-h" ]; then
    print_help;
fi


disk_exists=$(echo $lfdd_output | grep -o $disk_name);

if [ "$disk_exists" = "" ]; then
    echo -e "${red}${bold}FLASH DISK DRIVE NOT FOUND${normal}";
    echo -e "${red}${italic}Try another name like sdax, sdbx or sdcx for instance...${normal}${no_color}\n\n";
    lsblk -l | head -n 1;
    echo    '--------------------------------------------------------------------'
    echo "$lfdd_output"
    echo -e '--------------------------------------------------------------------\n'
    exit;
fi


if ! sudo umount /dev/$disk_name &> /dev/null; then
    echo -e "${red}${bold}FAILED TO UNMOUNT FLASH DISK${normal}";
    echo -e "${red}${italic} - ${disk_name} is certainly already unmounted.${normal}";
else
    echo -e "${blue}${bold}FLASH DISK SUCCESSFULLY UNMOUNTED${normal}";
    echo -e "${blue}${italic} - ${disk_name} is unmounted.${normal}";
fi

sudo eject /dev/$disk_name;

delete_symlink_file;
echo -ne '\n';
