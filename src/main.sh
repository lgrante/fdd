#!/usr/bin/bash


bold=$(tput bold);
normal=$(tput sgr0);
italic="\e[3m";
blue="\e[36m";
red="\e[31m";
no_color="\e[0m";


command_exec_keys=("list", "read", "eject");
declare -A command_executables=( [list]=list_fdd.sh [read]=read_fdd.sh [eject]=umount_fdd.sh );


print_help() {
    echo -e "\n${bold}USAGE${normal}\n\n";
    echo "fdd <list|read|eject> (...args)";
    echo -e "fdd (--help|-h)\n";
    echo -e "${italic}For more details about a command:${normal}\n";
    echo -e "fdd <list|read|eject> (--help|-h)\n"
    exit;
}


executable_arg=$1;

echo -ne "\n";

if [ "$executable_arg" = "" ] || [ ! -n "${command_exec_keys[$executable_arg]}" ]; then
    print_help;
fi

for i in "${!command_executables[@]}"; do
	if [ "${executable_arg}" = "${i}" ]; then
		arguments="${@:2}";

		echo $arguments;
		echo "~/.fdd/${command_executables[$i]} ${arguments}" | bash;
	fi
done

