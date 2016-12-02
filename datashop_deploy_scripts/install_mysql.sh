#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages


## Download RPM ##
echo "Downloading mysql rpm.."
wget http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm

## Install Mysql Commandline/
echo "Installing mysql.."
sudo yum update -y
sudo yum install mysql -y
sudo service mysqld start
echo "Mysql Successfully Installed."
