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
	}

install_redis(){
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
}

install_elasticsearch(){
	## Creating Repo ##
	echo "Creating elasticsearch repo.."
	cat << EOT >> elasticsearch.repo
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOT

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

