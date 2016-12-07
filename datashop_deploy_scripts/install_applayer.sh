#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

cat << EOM
		+------------------------------------------------+
		| This Script will install the Application Layer |
		| [both python and scala] on the server.	 |
		| **Dependencies: Git Mysql Mongo pip supercisor |
		+------------------------------------------------+
EOM
				
## Install necessary dependencies ##
sudo yum install vim git-core -y

##  Set permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

## Clone Repository ##
git clone http://git.innovaccer.com/Datashop/ApplicationLayer.git
cd ApplicationLayer

## Setup Application Layer Python
app_layer_python(){
	cd Python
	python setup.py develop
	python setup.py install
	pip install -r requirements.txt
	pip install supervisor

	## Adding to requirements ##
	pip install pipreqs
	pipreqs /home/project/location

	## Run in production mode
	supervisord -c supervisord.conf
	supervisorctl start all

	echo "Application Layer Python Successfully Installed"
}

## Setup Application Layer Scala
app_layer_scala(){
	cd /opt/packages
	sudo yum group install "Development Tools" -y
	sudo yum install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel -y

	git clone http://git.innovaccer.com/avijjapu/ApplicationLayerInstallation.git
	cd ApplicationLayerInstallation/nginx-1.9.7/
	./configure --prefix=/opt/nginx --add-module=../headers-more-nginx-module-0.30rc1
	make
	make install
	--->>>  Copy nginx.conf to nginx conf (/opt/nginx/conf) directory

	sudo /opt/nginx/sbin/nginx


	mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS core;"

	echo "Restoring mysql dumps to database.."
	
	cd ../mysqlDumps
	for dump_file in `ls`
	do	
		mysql -u root -p core < $dump_file
	do
	echo "MySql Dumps Sucessfully Restored.."

	echo "Loading Mongo Dumps to database"
	mongorestore dump/
	echo "Mongo Dumps Successfully Restored"

	cd /opt/packages
	wget https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10.zip
	unzip typesafe-activator-1.3.10.zip

	## Run in production mode ##
	cd activator-dist-1.3.10
	./bin/activator dist
	cd target/universal
	unzip applicationlayer-<version>.zip
	cp ../../supervisord.conf
	supervisord -c supervisord.conf

}
