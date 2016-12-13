#!/bin/bash
##__AUTHOR:RAJAN MIDDHA__##

sudo yum install figlet -y
clear

cat << EOM

		+--------------------------------------------+
		| This Script will setup WEB UI for Datashop |
		| care frontend deployment.		     |
		| **Dependencies: awscli python-pip	     |
		+--------------------------------------------+
EOM

figlet Web UI
sleep 5

## Install necessary packages ##
sudo yum install epel-release -y
sudo yum install python-pip python-wheel -y
sudo pip install awscli
sudo pip install --upgrade awscli
	 
######## Export aws credentials ########
export AWS_ACCESS_KEY_ID="access_key"
export AWS_SECRET_ACCESS_KEY="secret_key"
export AWS_DEFAULT_REGION="region"
xport AWS_DEFAULT_OUTPUT="json"

BUCKET_NAME="datashop-ui"
## Set Permissions ##
sudo chown $USER /opt
mkdir -p /opt/packages/web/
cd /opt/packages

## Change Permissions ##
sudo chown -R $USER /usr/local/lib/
sudo chown -R $USER /usr/local/share/
sudo chown -R $USER /usr/local/bin/

## Install node ##
wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz
sudo tar -C /usr/local --strip-components 1 -xf node-v6.9.1-linux-x64.tar.xz

## Download UI ZIP ##
DATE=$(date +%Y-%m-%d)

FILENAME=`AWS_ACCESS_KEY_ID="access_key" AWS_SECRET_ACCESS_KEY="secret_key" aws s3 ls s3://$BUCKET_NAME | grep ${DATE} | head -1 | awk '{print $4}'`

AWS_ACCESS_KEY_ID="access_key" AWS_SECRET_ACCESS_KEY="secret_keey" aws s3 cp s3://$BUCKET_NAME/$FILENAME web/

cd web/
tar -xvf $FILENAME

DIRECTORY=`echo $FILENAME | cut -d'.' -f1`
cd $DIRECTORY

## Start Service
./setup.sh
./start.sh
./stop.sh
./start.sh

echo "Web UI is successfully deployed"

