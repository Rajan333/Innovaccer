#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

set -e
 

get_root_size()
{
	ROOT_SIZE=`df -h | grep /dev/sda | awk '{print $5}' | tr -d '%'`
	ROOT_THRESHOLD=75

	if [ $ROOT_SIZE -gt $ROOT_THRESHOLD ];then
		echo `date` 'Sending critical email. Disk almost full.'
		mail -s 'Disk Space Alert' rajan.middha@innovaccer.com << EOF
		Your root partition remaining free space is critically low. Used: $ROOT_SIZE%
EOF
	fi
}

get_free_mem()
{
	FREE_RAM_SIZE=`free -m | grep  Mem | awk '{print $4}'`
	RAM_THRESHOLD=300
	if [ $FREE_RAM_SIZE -lt $RAM_THRESHOLD ];then
		echo `date` 'Sending critical email. Memory almost full.'
		mail -s 'Memory Space Alert' rajan.middha@innovaccer.com << EOF
		Free space on RAM is critically low. Used: $FREE_RAM_SIZE"MB"
EOF
	fi

}

get_root_size
get_free_mem
