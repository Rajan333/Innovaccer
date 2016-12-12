#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

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
sudo yum install elasticsearch -y
echo "ElasticSearch Sucessfully Installed."
