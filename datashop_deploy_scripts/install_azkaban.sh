#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

cat << EOM

	+-------------------------------------+
	| This script will install azkaban on |
	| server and set its database [mysql] |
	| on db server, set executor service  |
	| on pnn1 server, set web service on  |
	| current server.		      |
	+-------------------------------------+
EOM

sudo yum install figlet -y
clear
figlet Azkaban
sleep 5

## Set permissions
sudo chown -R $USER /opt
mkdir /opt/packages
cd /opt/packages

## Setup sshpass for authentication
if [ $USER == "centos" ];then
	wget http://download.opensuse.org/repositories/home:Strahlex/CentOS_7/home:Strahlex.repo
elif [ $USER == "ec2-user" ];then
	wget http://download.opensuse.org/repositories/home:Strahlex/RHEL_7/home:Strahlex.repo
else
	echo "Neither centos nor ec2-user"
	exit 3
fi

sudo mv home:Strahlex.repo /etc/yum.repos.d/
sudo yum install sshpass -y

## Download Azkaban 2.5 ##
mkdir -p Azkaban
cd Azkaban
sshpass -p password scp -o "StrictHostKeyChecking no" user@sftp_ip:Azkaban_updated.zip .
unzip Azkaban_updated.zip

## Set config ##

## Sync services to the server ##
scp -o "StrictHostKeyChecking no" schema.sql db:

## Set Configurations on db_server ##
ssh db << ENDOFCOMMANDS
mysql -u root -proot -e "CREATE DATABASE azkaban;"
mysql -u root -proot azkaban < schema.sql 
sudo chmod 777 /etc/my.cnf
echo "max_allowed_packet=1024M" >> /etc/my.cnf
sudo /sbin/service mysqld restart
ENDOFCOMMANDS

## Start services on the server ##
cd azkaban-executor-2.5.0
./bin/azkaban-executor-start.sh

cd ../azkaban-web-2.5.0
./bin/azkaban-web-start.sh

echo "Azkaban Installation Successfully Completed.. "
echo "Running on port no. 9081"
