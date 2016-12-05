#!/bin/bash

cat << EOM

	+-------------------------------------+
	| This script will install azkaban on |
	| server and set its database [mysql] |
	| on db server, set executor service  |
	| on pnn1 server, set web service on  |
	| current server.		      |
	+-------------------------------------+
EOM

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
sudo yum update -y
sudo yum install sshpass -y

## Download Azkaban 2.5 ##
mkdir -p Azkaban
cd Azkaban
sshpass -p inno scp -o "StrictHostKeyChecking no" inno@54.68.6.74:Azkaban.zip .
unzip Azkaban.zip

## Set config ##

## Sync services to the server ##
scp -o "StrictHostKeyChecking no" schema.sql db:
scp -o "StrictHostKeyChecking no" -r azkaban-executor-2.5.0 pnn1:

## Set Configurations on db_server ##
ssh db << ENDOFCOMMANDS
mysql -u root -proot -e "CREATE DATABASE azkaban;"
mysql -u root -proot azkaban < schema.sql 
sudo chmod 777 /etc/my.cnf
echo "max_allowed_packet=1024M" >> /etc/my.cnf
sudo /sbin/service mysqld restart
ENDOFCOMMANDS

## Start services on the server ##
ssh pnn1 << ENDOFCOMMANDS
cd azkaban-executor-2.5.0
./bin/azkaban-executor-start.sh
ENDOFCOMMANDS

cd azkaban-web-2.5.0
./bin/azkaban-web-start.sh

echo "Azkaban Installation Successfully Completed.. "
echo "Running on port no. 9081"
