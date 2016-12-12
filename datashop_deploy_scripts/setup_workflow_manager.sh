#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

cat << EOM
		+-----------------------------------------+
		| This Script will setup WorkFlow Manager |
		| and Install its required dependencies	  |
		| on the server.			  |
		+-----------------------------------------+ 
EOM

## Install necessary packages
sudo yum install git-core epel-release -y
sudo yum upgrade python-setuptools -y 
sudo yum install python-pip python-wheel -y
sudo yum install mysql mysql-devel mysql-lib -y
sudo pip install flask MySQL-python thoonk redis gevent pymongo


## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages/WorkFlowManagerAPI
cd /opt/packages/WorkFlowManagerAPI

## Clone Repository ##
git init
git remote add origin http://git.innovaccer.com/sharath.akinapally/WorkFlowManagerAPI.git
git pull origin staging

cd WorkFlowManagerAPI

echo "Update config.py and Run Command 'python server.py' to start"

