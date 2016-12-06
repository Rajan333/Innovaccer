#!/bin/bash
##__AUTHOR:RAJAN MIDDHA__##

cat << EOM

		+--------------------------------------------+
		| This Script will setup WEB UI for Datashop |
		| care frontend deployment.		     |
		| 	**Dependencies: awscli		     |
		+--------------------------------------------+
EOM

## Install necessary packages ##
sudo yum install epel-release -y
sudo yum install python-pip python-wheel -y
sudo pip install awscli
sudo pip install --upgrade awscli
	 
######## Export aws credentials ########
export AWS_ACCESS_KEY_ID="AKIAJMCRFJFK7E5P6DWQ"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-west-2"
export AWS_DEFAULT_OUTPUT="json"

BUCKET_NAME="datashop-ui"
## Set Permissions ##
sudo chown $USER /opt
mkdir -p /opt/packages/web/

## Change Permissions ##
sudo chown -R $USER /usr/local/lib/
sudo chown -R $USER /usr/local/share/
sudo chown -R $USER /usr/local/bin/

## Install node ##
wget https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz
sudo tar -C /usr/local --strip-components 1 -xf node-v6.9.1-linux-x64.tar.xz

## Download UI ZIP ##
DATE=$(date +%Y-%m-%d)
FILENAME=`aws s3 ls s3://BUCKET_NAME | grep ${DATE} | head -1 | awk '{print $4}'`
aws s3 cp s3://$BUCKET_NAME/$FILENAME .

tar -xvf $FILENAME

## Start Service
./setup.sh
./start.sh
./stop.sh
./start.sh

echo "Web UI is successfully deployed"

