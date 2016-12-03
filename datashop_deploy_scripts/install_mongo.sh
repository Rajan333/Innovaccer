#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

## Creating Repo ##
echo "Creating mongodb Repo.."
touch mongodb.repo
echo "[MongoDB]" >> mongodb.repo
echo "name=MongoDB Repository" >> mongodb.repo
echo "baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/" >> mongodb.repo
echo "gpgcheck=0" >> mongodb.repo
echo "enabled=1" >> mongodb.repo


sudo mv mongodb.repo /etc/yum.repos.d/
cd

## Update Yum & Install Mongo ##
echo "Installing mongodb.."
sudo yum update -y
sudo yum install -y mongodb-org
sudo service mongod start
sudo chkconfig mongod on
echo "Mongodb Successfully Installed."
