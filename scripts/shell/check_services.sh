#!/bin/bash

###___AUTHOR:RAJAN MIDDHA___###
###__This Script must run with sudo___###

set -e

check_root()
{
	AMIROOT=`whoami`
	if [ $AMIROOT != "root" ];then
		echo "This script can only run by ROOT user...!!!"
		exit 3
	fi
}

check_nginx_status()
{
	NGINX_STATUS=`service nginx status  | grep active | awk '{print $2}'`
	if [ $NGINX_STATUS == "active" ];then
		echo "nginx is running successfully"
	else
		echo "nginx is not running. Plz Check..!!!"
	fi
}

check_mysql_status()
{
	MYSQL_STATUS=`service mysqld status | grep Active | awk '{print $3}' | tr -d '()'`
	if [ $MYSQL_STATUS == "running" ];then
		echo "mysql is running successfully"
	else
		echo "mysql is not running. Plz Check..!!!"

	fi
}

check_mongodb_status()
{
	MONGODB_STATUS=`service mongodb status`
	if [ $MONGODB_STATUS == "running" ];then
		echo "mongodb is running successfully"
	else
		echo "mongodb not running. Plz Check..!!!"
	fi
}

check_spark_status()
{
	SPARK_STATUS=`service spark status  | grep Active | awk '{print $2}'`
	if [ $SPARK_STATUS == "active" ];then
		echo "spark is running successfully"
	else
		echo "spark is not running. Plz Check..!!!"
	fi
}

check_ambari_status()
{
	AMBARI_STATUS=`service ambari-server status | grep "Ambari Server" | head -1 | awk '{print $3}'`
	if [ $AMBARI_STATUS == "running" ];then
		echo "Ambari is running successfully"
	else 
		echo "Ambari is not running successfully. Plz Check..!!!"
	fi
}

check_root
check_nginx_status
check_mysql_status
check_mongodb_status
check_spark_status
check_ambari_status
