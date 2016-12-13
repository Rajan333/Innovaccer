#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

sudo yum install figlet -y
clear

cat << EOM
	+--------------------------------------+
	| This Script will setup Job Registery |
	| on server and install all necessary  |
	| dependencies on the server	       |
	+--------------------------------------+
EOM
figlet Job Registry
sleep 5

GIT_USERNAME="platform"
GIT_PASSWORD="innovation123"

## Install Dependencies ##
sudo yum install git-core -y
sudo yum upgrade python-setuptools -y
sudo yum install python-pip python-wheel -y
sudo pip install supervisor
echo "Dependencies Successfully Installed"

## Clone Repo ##
echo "machine git.innovaccer.com login $GIT_USERNAME password $GIT_PASSWORD" >> ~/.netrc
git clone http://git.innovaccer.com/Datashop/JobRegistry.git
echo "Job Registry Repo Cloned"

echo "Update config.py and run command 'supervisord -c supervisord.conf'"

