#!/bin/bash
###___AUTHOR: RAJAN MIDDHA___###

cat << ENDOFFILE

		+------------------------------------------------+
		| This Script will install Spark job Server and	 |
		| sbt on the server.			    	 |
		| Dependencies:: git must be installed on server |
		+------------------------------------------------+
ENDOFFILE

sudo yum install figlet -y
figlet Spark Job Server
sleep 3

## Install git if not installed ##
sudo yum install git-core -y
			
## Clone Spark Job Server Repo ##
git clone https://github.com/spark-jobserver/spark-jobserver.git
cd spark-jobserver/
git checkout v0.6.2

## Install SBT ##
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt -y
sbt clean update package assembly


## Setup yarn.sh and yarn.conf ##
cat << EOT >> ~/spark-jobserver/config/yarn.sh
DEPLOY_HOST="localhost"
APP_USER=spark
APP_GROUP=spark
LOG_DIR=/var/log/job-server
PIDFILE=spark-jobserver.pid
JOBSERVER_MEMORY=2G
SPARK_VERSION=1.6.2
MAX_DIRECT_MEMORY=512M
SPARK_HOME=/usr/hdp/current/spark-client
SPARK_CONF_DIR=$SPARK_HOME/conf
SCALA_VERSION=2.10.5
EOT 

cat << EOT >> ~/spark-jobserver/config/yarn.conf
spark {
	master = "yarn-client"
	job-number-cpus = 4
	jobserver {
		port = 8090
		jar-store-rootdir = /opt/packages/jobserver/jars
		context-per-jvm = true
		jobdao = spark.jobserver.io.JobFileDAO
		filedao {
			rootdir = /opt/packages/spark-job-server/filedao/data
		}
		result-chunk-size = 1m
		}
	context-settings {
		num-cpu-cores = 4
		memory-per-node = 2G
		passthrough {
			es.nodes = "db"
			es.port = "9200"
			es.index.auto.create = "false"
		}
	}
}
akka {
	remote.netty.tcp {
		maximum-frame-size = 100Mib
		}
}	
EOT

#curl --header "PRIVATE-TOKEN: 2txfzrEGHbWD5WW79BKU " http://git.innovaccer.com/snippets/90/raw >> ~/spark-jobserver/config/yarn.sh
#curl --header "PRIVATE-TOKEN: 2txfzrEGHbWD5WW79BKU" http://git.innovaccer.com/snippets/89/raw >> ~/spark-jobserver/config/yarn.conf

## Install Service
bin/server_package.sh yarn

## Start Service
cd /tmp/job-server
./server_start.sh

echo "Spark Job Server Successfully Deployed.."
