#!/usr/bin/bash

alias_command="alias fdd='bash $(pwd)/src/main.sh'"

sudo mkdir ~/.fdd &> /dev/null;
sudo cp ./src/* ~/.fdd &> /dev/null;

if test -f ~/.zshrc; then
	echo $alias_command >> ~/.zshrc;
	zsh;
elif test -f ~/.bashrc; then
	echo $alias_command >> ~/.bashrc;
	bash;
fi
