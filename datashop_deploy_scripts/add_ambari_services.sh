#!/bin/bash
###__AUTHOR: RAJAN MIDDHA___###

install_mongo(){
	echo "Adding Mongo in Ambari-Stack"
	git clone https://github.com/nikunjness/mongo-ambari.git
	sudo mv mongo-ambari /var/lib/ambari-server/resources/stacks/HDP/2.4/services/MONGODB
	echo "Mongo added in Ambari-Stack"
}

install_redis(){
	echo "Adding Redis in Ambari-Stack"
	git clone https://github.com/nikunjness/redis-ambari.git
	sudo mv redis-ambari /var/lib/ambari-server/resources/stacks/HDP/2.4/services/REDIS
	echo "Redis added in Ambari-Stack"
}

install_elastic(){
	echo "Adding ElasticSearch in Ambari-Stack"
	git clone https://github.com/Symantec/ambari-elasticsearch-service.git
	sudo mv ambari-elasticsearch-service /var/lib/ambari-server/resources/stacks/HDP/2.4/services/ELASTICSEARCH
	echo "ElasticSearch added in Ambari-Stack"
}

install_azkaban(){
	echo "Adding Azkaban in Ambari-Stack"
	git clone http://www.redhub.io/OpenBI/ambari-azkaban-service.git
	sudo mv ambari-azkaban-service/AZKABAN /var/lib/ambari-server/resources/stacks/HDP/2.4/services/
	sudo rm -rf ambari-azkaban-service
	echo "Azkaban added in Ambari-Stack"
}

sudo mkdir -p /opt/packages
sudo chown -R $USER /opt
cd /opt/packages
install_mongo
install_redis
install_elastic
install_azkaban
cd
sudo ambari-server restart 
echo "All services are successfully added to ambari.."


