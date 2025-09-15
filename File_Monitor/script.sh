#!/bin/bash

current_dir=<path>/File_Monitor
echo -e "\n$(date) EXEC: check.sh executed " >> $current_dir/LOGS/LOGS.log

for file in $(cat $current_dir/protectected_files)
do
	if [ ! -f "$file" ]
	then
		echo -e "\n$(date) WARNING: Protected file $file does not exist, renamed or deleted" >> $current_dir/LOGS/LOGS.log
		continue
	fi
	
	known_hash=$(cat "$current_dir/hashes/$(basename $file).hash")
	hash_check=$(openssl sha256 $file | awk '{ print $2 }')
	
	if [[ "$known_hash" != "$hash_check" ]]
	then
		#echo "FILE $(basename $file) ALTERED"
		#echo "Do you want to revert to old version: y/n"
		#read opt
		#if [ $opt  == "y" ]
		#then
		#	cp "backups/$(basename $file).backup" "$file"
		#else
		#	echo "No auto revert error will reoccur until reverted or remove file from "
		echo -e "\n--------------------------------------------------------------------------------------------------------------------------" >> "$current_dir/LOGS/FILE_CHANGE.log"
		{ echo -e "$(date) \nFILE: $file \nKNOWN_HASH:$known_hash \nCALCULATED_HASH: $hash_check\n" >> "$current_dir/LOGS/FILE_CHANGE.log"; } && { diff -c $current_dir/backups/$(basename $file).backup $file >> "$current_dir/LOGS/FILE_CHANGE.log"; }
		sudo cp "$current_dir/backups/$(basename $file).backup" "$file"
		echo -e "\n--------------------------------------------------------------------------------------------------------------------------">> $current_dir/LOGS/LOGS.log
		echo -e "$(date) FAIL: Protected file $file integrity check FAIL" >> $current_dir/LOGS/LOGS.log
		echo "$(date) WARNING: REVERTED FILE TO LATEST BACKUP OF $file" >> $current_dir/LOGS/LOGS.log
		echo -e "--------------------------------------------------------------------------------------------------------------------------">> $current_dir/LOGS/LOGS.log
		#fi
	else
		echo -e "\n$(date) PASS: Protected file $file check SUCCESS" >> $current_dir/LOGS/LOGS.log
	fi
done
