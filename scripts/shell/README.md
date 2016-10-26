# Innovaccer

## check_load.sh
	Objective: To check load on a machine  
	Description: This script will check whether the Root partition and Free Memory on the servers are free or not. If it exceeds the load threshold, then it will send a critical mail alert.  
	Usage: bash check_load.sh


## check_services.sh
	Objective: To check all services on the machine  
	Description: This script will check whether services like mysql,nginx,mongodb,spark,ambari are currently running or not.  
	Usage: sudo bash check_services.sh  


## check_executables.sh
	Objective: To check working of all commands   
	Description: This script will check exit status of all the executables that exist in path variables by executing the commands and it will check status using  --help or --version in case of interactive commands.  
	Usage: bash check_executables.sh

## git_backup.sh 
	Objective: To take git backup  
	Description: This script will take backup of git repos (in tar.gz format) and store it to s3 bucket. This script stores backups for last 15 days and remove the old backups.  
	Dependencies: awscli  
	Usage: bash git_bakup.sh
