#!/bin/bash
##__AUTHOR: RAJAN MIDDHA ##

## Install necessary packages
sudo yum install mysql mysql-devel mysql-lib -y
sudo pip install flask MySQL-python thoonk redis gevent pymongo


## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages/WorkFlowManagerAPI
cd /opt/packages/WorkFlowManagerAPI

## Clone Repository ##
git init
git remote add origin http://git.innovaccer.com/DatashopCore/Services.git
git pull origin/WorkflowConfiguration

## Update config.py ##

## Start WorkFlowManager ##
sudo python setup.py install
cd WorkFlowManagerAPI
sudo python server.py





