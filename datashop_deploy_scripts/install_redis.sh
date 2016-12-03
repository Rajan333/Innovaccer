#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

## Download Package ##
echo "Downloading Redis Package.."
wget http://download.redis.io/releases/redis-3.2.5.tar.gz
sudo  tar xzf redis-3.2.5.tar.gz
cd redis-3.2.5

## Install Redis ##
echo "Installing Redis.."
sudo make
sudo src/redis-server &
echo "Redis Successfully Installed."
