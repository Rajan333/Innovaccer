#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages


## Download RPM ##
echo "Downloading mysql rpm.."
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm

## Install Mysql Commandline/
echo "Installing mysql.."
sudo yum update -y
sudo yum install mysql-server -y
sudo service mysqld start
sudo mysql_secure_installation
mysql -u root -proot -e "GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'root';"
echo "Mysql Successfully Installed."
