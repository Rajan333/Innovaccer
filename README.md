Scripts for datashop deployment

## install_nginx.sh
Install `nginx-1.10` on server


## install_ambari.sh
Install `ambari-2.2.2.0` on server
Install `HDP stack-2.4`

## add_ambari_services.sh
Add Services in ambari

## install_db.sh
Install `mysql-5.7.16`,`mongodb-3.2.0`,`redis-3.2.5`,elasticsearch-2.4.0` on server

## install_mysql.sh
Install `mysql-5.7.16` on server
	
## install_mongo.sh
Install `mongodb-3.2.0` on server
	
## install_redis.sh
Install `redis-3.2.5` on server
	
## install_elasticsearch.sh
Install `elasticsearch-2.4.0` on server
	
## install_azkaban.sh
Install Azkaban-2.5.0 on server
Install azkaban db on db_server
Run on `port_no.`: `9081`

## setup_webui.sh
Setup web interface
Install necessary modules

## mysql_backup.sh
Take backup of mysql db from db_server
Store backups to s3 `bucket_name`:`inno-mysql-backups`
Delete backups older than 15 days

## mongodb_backup.sh
Take backup of mongo db from db_server
Store backup to s3 `bucket_name`:`inno-mongodb-backups`
Delete backups older than 15 days

## deploy_spark_job_server.sh
Install all necessary dependencies for deployment of spark job server and deploy it

