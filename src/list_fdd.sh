#!/usr/bin/bash


bold=$(tput bold);
normal=$(tput sgr0);
italic="\e[3m";


echo -en '\n';


fdd_list_output=$(lsblk | grep -e 'disk');


echo -e "${bold}ACTIVE FLASH DISKS DRIVE${normal}\n";
lsblk -l | head -n 1;
echo    '--------------------------------------------------------------------'
lsblk -l | awk '$6 ~ /disk/ {getline;} $6 ~ /part/ {print;}'
echo -e '--------------------------------------------------------------------\n'
exit;
