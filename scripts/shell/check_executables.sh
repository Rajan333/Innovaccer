#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

cat<<EOM

	+-----------------------------------------------+
	| This script will check the exit status of all |
	| executables & It will check the command with  |
	| its --version or --help if it is interactive. |
	+-----------------------------------------------+

EOM

sleep 3

declare -a help_array=(chgpasswd chpasswd cppw cpgr cups-browsed cups-calibrate localedef locale-gen)
declare -a version_array=(alsa-info.sh lpc postcat postdrop postlock postlog pppdump rmt rmt-tar sendmail 411toppm)
declare -a ignore_array=(cracklib-check cracklib-format lightdm-session pam-auth-update pppoeconf rtmpsrv rtmpsuck)

echo " " > executables.log

for each_path in `echo ${PATH//:/ }`
do
	echo "Looking in Path: " $each_path >> executables.log
	sleep 2
	for each_command in `ls $each_path`
	do	
		flag=0
		echo "COMMAND :" $each_command >> executables.log
		sleep 1
		for hlp_comm in ${help_array[@]}
		do
			if [ "$hlp_comm" == "$each_command" ];then
				$each_command --help
				STATUS="$?"
					echo "$each_command" :: "$STATUS" >> executables.log
				flag=1
			fi		
		done

		for ver_comm in ${version_array[@]}
		do
			if [ "$ver_comm" == "$each_command" ];then
				$each_command --version
				STATUS="$?"
				echo "$each_command" :: "$STATUS" >> executables.log		
				flag=1
			fi
		done
		
		for ign_comm in ${ignore_array[@]}
		do
			if [ "$ign_comm" == "$each_command" ];then
				echo "Ingoring: $ign_comm" >> executables.log
				flag=1
			fi
		done

		if [ "$flag" = "0" ];then
		 	$each_command
			STATUS="$?"
			echo "$each_command" :: "$STATUS" >> executables.log
		fi	
	done
done

