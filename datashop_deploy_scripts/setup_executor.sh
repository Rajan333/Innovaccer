#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

sudo yum install figlet -y
clear

cat << EOM
		+-------------------------------------------+
		| This Script will setup executor on server |
		| and install all required dependencies	    |
		+-------------------------------------------+
EOM
figlet Executor
sleep 5

GIT_USERNAME="username"
GIT_PASSWORD="password"

## Set permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages/Jobs
mkdir -p /opt/packages/jars
cd /opt/packages/Jobs

## Install sbt ##
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum install sbt -y
sudo yum install git-core -y

## Clone Repo ##
echo "machine git.innovaccer.com login $GIT_USERNAME password $GIT_PASSWORD" >> ~/.netrc
git init
git remote add origin http://git.innovaccer.com/Datashop/Jobs.git
git pull origin project/development

## Setup Executor ##
cd executor
sbt clean compile assembly
#cp -afv target/scala-2.11/com/datashop/executors-assembly-1.0.jar /opt/packages/jars/
cd target/scala-*
cp -afv com/datashop/executors-assembly-1.0.jar /opt/packages/jars/
cd

echo "Executor Setup Process Successfully Completed"



