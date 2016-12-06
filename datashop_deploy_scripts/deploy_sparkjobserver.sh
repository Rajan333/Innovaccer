#!/bin/bash
###___AUTHOR: RAJAN MIDDHA___###

cat << ENDOFFILE

		+------------------------------------------------+
		| This Script will install Spark job Server and	 |
		| sbt on the server.			    	 |
		| Dependencies:: git must be installed on server |
		+------------------------------------------------+
ENDOFFILE

## Install git if not installed ##
sudo yum installed git-core -y
			
## Clone Spark Job Server Repo ##
git clone https://github.com/spark-jobserver/spark-jobserver.git
cd spark-jobserver/
git checkout v0.6.2

## Install SBT ##
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt -y
sbt clean update package assembly

## Download yarn.sh and yarn.conf 
curl --header "PRIVATE-TOKEN: 2txfzrEGHbWD5WW79BKU " http://git.innovaccer.com/snippets/90/raw >> ~/spark-jobserver/config/yarn.sh
curl --header "PRIVATE-TOKEN: 2txfzrEGHbWD5WW79BKU" http://git.innovaccer.com/snippets/89/raw >> ~/spark-jobserver/config/yarn.conf

## Install Service
bin/server_package.sh yarn

## Start Service
cd /tmp/job-server
./server_start.sh

echo "Spark Job Server Successfully Deployed.."
