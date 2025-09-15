# File Monitor

```
DEPENDENCIES:  
  sudo apt install openssl

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
  ./setup.sh

NOTES:
[>] Once setup.sh is run; add to crontab appropriate command for script.sh
    (e.g., 0 * * * * bash /path/to/File_Monitor/script.sh)
[!] If setup is run again, new backup file is created and previous one is deleted,
    so change file location of previous backup if needed
```
