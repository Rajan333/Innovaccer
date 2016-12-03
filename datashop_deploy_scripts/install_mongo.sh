#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

## Creating Repo ##
echo "Creating mongodb Repo.."
cat<<EOT >> mongodb-org-3.2.repo
[mongodb-org-3.2] 
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
EOT

sudo mv mongodb-org-3.2.repo /etc/yum.repos.d/
cd

## Update Yum & Install Mongo ##
echo "Installing mongodb.."
sudo yum update -y
sudo yum install -y mongodb-org
sudo service mongod start
sudo chkconfig mongod on
echo "Mongodb Successfully Installed."
