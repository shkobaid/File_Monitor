# File Monitor

DEPENDENCIES:  
  
1) sudo apt install openssl  

FILE STRUCTURE: 
  
File_Monitor 
|  
|- LOGS  
|- script.sh  
|- setup.sh
L  protected_files
  
CLI COMMANDS:  
  
git clone https://github.com/shkobaid/File_Monitor.git  
cd File_Monitor 
chmod +x setup.sh
./OPHISHER.sh  

NOTES:

Once setup.sh is run; add to crontab appropriate command for script.sh  ( 0 * * * * bash <path>/File_Monitor/script.sh
If setup is run again, new backup file is created and previous one is deleted, so change file location of previous backup if needed
