#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

## Creating Repo ##
echo "Creating mongodb Repo.."
touch mongodb-org-3.2.repo
echo "[mongodb-org-3.2]" >> mongodb-org-3.2.repo
echo "name=MongoDB Repository" >> mongodb-org-3.2.repo
echo "baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/" >> mongodb-org-3.2.repo
echo "gpgcheck=1" >> mongodb-org-3.2.repo
echo "enabled=1" >> mongodb-org-3.2.repo
echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc" >> mongodb-org-3.2.repo


sudo mv mongodb-org-3.2.repo /etc/yum.repos.d/mongodb-org-3.2.repo
cd

## Update Yum & Install Mongo ##
echo "Installing mongodb.."
sudo yum update -y
sudo yum install -y mongodb-org
sudo service mongod start
echo "Mongodb Successfully Installed."
