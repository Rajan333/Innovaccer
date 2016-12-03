#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

install_mysql(){
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
	echo "Mysql Successfully Installed."	
}

install_mongo(){
	## Creating Repo ##
	echo "Creating mongodb Repo.."
	touch mongodb-org-3.2.repo
	echo "[mongodb-org-3.2]" >> mongodb-org-3.2.repo
	echo "name=MongoDB Repository" >> mongodb-org-3.2.repo
	echo "baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/" >> mongodb-org-3.2.repo
	echo "gpgcheck=0" >> mongodb-org-3.2.repo
	echo "enabled=1" >> mongodb-org-3.2.repo


	sudo mv mongodb-org-3.2.repo /etc/yum.repos.d/
	cd

	## Update Yum & Install Mongo ##
	echo "Installing mongodb.."
	sudo yum update -y
	sudo yum install -y mongodb-org
	sudo service mongod start
	sudo chkconfig mongod on
	echo "Mongodb Successfully Installed."
}

install_redis(){
	
	## Download Package ##
	echo "Downloading Redis Package.."
	wget http://download.redis.io/releases/redis-3.2.5.tar.gz
	tar -xzvf redis-3.2.5.tar.gz
	cd redis-3.2.5

	## Install Redis ##
	echo "Installing Redis.."
	make
	src/redis-server &
	echo "Redis Successfully Installed."
}

install_elasticsearch(){

	## Creating Repo ##
	echo "Creating elasticsearch repo.."
	touch elasticsearch.repo
	echo "[elasticsearch-2.x]" >> elasticsearch.repo
	echo "name=Elasticsearch repository for 2.x packages" >> elasticsearch.repo
	echo "baseurl=https://packages.elastic.co/elasticsearch/2.x/centos" >> elasticsearch.repo
	echo "gpgcheck=1" >> elasticsearch.repo
	echo "gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch" >> elasticsearch.repo
	echo "enabled=1" >> elasticsearch.repo

	sudo mv elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
	cd

	## Update Yum & Install Mongo ##
	echo "Installing ElasticSearch.."
	sudo yum update -y
	sudo yum install elasticsearch -y
	echo "ElasticSearch Sucessfully Installed."
}

install_mysql
install_mongo
install_redis
install_elasticsearch

