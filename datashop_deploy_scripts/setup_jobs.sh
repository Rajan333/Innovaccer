#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

sudo yum install figlet -y
clear
cat << EOM
		+--------------------------------+
		| This Script will setup Jobs on |
		| the server & also install all  |
		| its required dependencies.	 |
		+--------------------------------+
EOM

figlet J o b s
sleep 5

GIT_USERNAME="username"
GIT_PASSWORD="password"

## Set permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages/jobs
cd /opt/packages/jobs

## Install sbt ##
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt -y
sudo yum install git-core -y

## Clone Repo ##
echo "machine git.innovaccer.com login $GIT_USERNAME password $GIT_PASSWORD" >> ~/.netrc
git init
git remote add origin http://git.innovaccer.com/Datashop/TestPackage.git
git pull origin develop

## Setup Jobs ##
sbt clean compile assembly
cd target/scala-*

## Make Curl Request on server on which spark job server is running ##
curl --data-binary @Datashop-assembly-1.0.jar rsm:8090/jars/datashop

echo "Done."
