#!/usr/bin/bash


bold=$(tput bold);
normal=$(tput sgr0);
italic="\e[3m";
blue="\e[36m";
red="\e[31m";
no_color="\e[0m";

disk_name=$1;
symlink_path_flag=$2;
symlink_path_value=$3;

print_help() {
    echo -e "${bold}USAGE${normal}\n\n";
    echo "fdd read [DISK_NAME]";
    echo "fdd read [DISK_NAME] (--symlink | -sl) [SYMLINK_PATH]";
    echo -e "fdd read (--help | -h)\n";
    exit;
}

echo -ne "\n";


if [ "$disk_name" = "" ] || [ "$disk_name" = "--help" ] || [ "$disk_name" = "-h" ]; then
    print_help;
fi


lfdd_output=$(lsblk -l | awk '$6 ~ /disk/ {getline;} $6 ~ /part/ {print;}');
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

mount_point="/media/${disk_name}";

{
    sudo mkdir -p $mount_point;
    sudo umount $mount_point;
} &> /dev/null

if ! sudo mount /dev/$disk_name $mount_point; then
    echo -e "${red}${bold}FAILED TO MOUNT FLASH DISK${normal}";
    echo -e "${red}${italic} - ${disk_name} not mounted\n"; 
    exit;
fi

echo -e "${blue}${bold}FLASH DISK SUCCESSFULLY MOUNTED${normal}";
echo -e "${blue}${italic} - ${disk_name} mounted to ${mount_point}${normal}"; 

if [ "$symlink_path_flag" = "--symlink" ] || [ "$symlink_path_flag" = "-sl" ]; then

    if [ "$symlink_path_value" != "" ]; then

	if ! sudo ln -s $mount_point $symlink_path_value &> /dev/null; then
	    echo -e "${red}${italic} - Failed to create symbolic link to ${symlink_path_value}\n";
	else
	    echo -e "${blue}${italic} - Symlink successfully created to ${symlink_path_value}";
	fi

    else 
	print_help;
    fi
fi

echo -e "${no_color}${italic}\nYou can acces to the disk folder with:";

if [ "$symlink_path_flag" != "" ] && [ "$symlink_path_value" != "" ]; then
    echo -e "cd $symlink_path_value\n";
    echo "${mount_point} ${symlink_path_value}" > .mounted_disks;
else
    echo -e "cd $mount_point\n";
fi

echo -e "${normal}";
echo -e '--------------------------------------------------------------------'
ls -l ${mount_point};
echo -e '--------------------------------------------------------------------\n'
echo -ne "\n";

