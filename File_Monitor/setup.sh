#!/bin/bash

bold="\e[1m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
normal="\e[0m"
aqua="\e[36m"
purple="\e[35m"
lightyellow="\e[93m"
orange="\e[33m"
RED="\e[41m"
GREEN="\e[42m"

current_dir=$(pwd)

if [ ! $EUID = 0 ]
then
	echo -n -e "\n${RED}${black}[!]YOU NEED TO BE ROOT (sudo)${normal}\n"
	exit 0
fi

if [ ! -d $current_dir/LOGS ]
then
	mkdir LOGS
	echo -e "\n$(date) BACKUP: Created directory \'LOGS\'" >> $current_dir/LOGS/LOGS.log
	echo -e "\n${red}[+] Created directory \"LOGS\"${normal}"
fi

echo -e "\n$(date) EXEC: setup.sh executed" >> $current_dir/LOGS/LOGS.log

function create_hashes(){
for file in $(cat $current_dir/protectected_files)
do
	
	if [ ! -f "$file" ]
	then
		echo -e "\n$(date) WARNING: Protected file $file does not exist; Unable to create hash" >> $current_dir/LOGS/LOGS.log
		continue
	fi
	
	if [ ! -d $current_dir/hashes ]
	then
		mkdir $current_dir/hashes
	fi
	
	{ hash=$(openssl sha256 $file | awk '{ print $2 }') && echo "$hash" > $current_dir/hashes/$(basename $file).hash  && echo -e "\n$(date) HASH: Hash created for protected file $file" >> $current_dir/LOGS/LOGS.log; } || echo "${red}[!]Error cannot create hash${normal}" 
done
}

function create_backups(){

	for file in $(cat $current_dir/protectected_files)
	do
		if [ ! -f "$file" ]
		then
			echo -e "\n$(date) WARNING: File $file does not exist; Unable to create backup" >> $current_dir/LOGS/LOGS.log
			continue
		fi
		
		if [ ! -d $current_dir/backups ]
		then
			mkdir $current_dir/backups
		fi
		
		if [ -f "backups/$(basename $file).backup" ]
		then
			echo -e "\n$(date) BACKUP: Removed previous backupfile for $file" >> $current_dir/LOGS/LOGS.log
			rm "backups/$(basename $file).backup"
		fi
		echo -e "\n$(date) BACKUP: Adding new backup for $file" >> $current_dir/LOGS/LOGS.log
		cp "$file" "backups/$(basename $file).backup" 
	done
}


create_hashes

if [ $? = 0 ]
then
	echo -e "\n${green}[>] Hashes successfully Created${normal}"
else
	echo -e "\n${red}[!] Error creating hashes${normal}"
	exit 1
fi

create_backups

if [ $? = 0 ]
then
	echo -e "\n${green}[>] Backups successfully Created${normal}"
else
	echo -e "\n${red}[!] Error creating backups${normal}"
	exit
fi

echo -e "\n${green}[+]Successfully created backups and hashes for protected file${normal}"
echo -e "\n${aqua}[!]${aqua} Run ${lightyellow} sudo crontab -e ${aqua} then add command ${lightyellow} 0 * * * * bash <path>/script.sh ${aqua} to nano text file${normal}"
