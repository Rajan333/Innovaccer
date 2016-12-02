#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__##

## Set Permissions ##
sudo chown -R $USER /opt
mkdir -p /opt/packages
cd /opt/packages

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
