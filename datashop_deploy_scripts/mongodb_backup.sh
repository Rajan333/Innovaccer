#!/bin/bash
##__AUTHOR: RAJAN MIDDHA__## 

cat << EOM	
		+---------------------------------------+
		| This Script will take dumps [backups] |
		| of mongodb databases and store backup |
		| on s3 bucket and remove the previous  |
		| backups [15 days before]		|
		+---------------------------------------+
EOM  


## Set Variables ##
BUCKET_NAME="inno-mongo-backups"
MONGO_DATABASE="db_name"
MONGO_HOST="db"
MONGO_PORT="27017"
TIMESTAMP=`date +%d-%b-%y`
OLD_TIMESTAMP=`date +%d-%b-%y --date "15 days ago"`
MONGODUMP_PATH="/usr/bin/mongodump"
BACKUPS_DIR="mongo-dump"
BACKUP_NAME="$BACKUPS_DIR-$TIMESTAMP"
OLD_FILENAME="$BACKUPS_DIR-$OLD_TIMESTAMP"

mongodb_backup(){

	## Create Mongo Dump ##
	echo "Creating Mongo Dump.." >> mongodb_backup.log
	$MONGODUMP_PATH -h $MONGO_HOST:$MONGO_PORT -d $MONGO_DATABASE
	#$MONGODUMP_PATH -d $MONGO_DATABASE
	echo "Mongo Dump Created" >> mongodb_backup.log

	echo "Creating tar of dump..."
	mkdir -p $BACKUPS_DIR old_dump
	mv dump $BACKUP_NAME
	tar -zcvf $BACKUPS_DIR/$BACKUP_NAME.tar.gz $BACKUP_NAME
	rm -rf $BACKUP_NAME
	echo "Tar file Created" >> mongodb_backup.log
	echo "Filename: $BACKUP_NAME.tar.gz" >> mongodb_backup.log

	##  Transfer Backup to s3 ##
	echo "Transferring Backup to s3.." >> mongodb_backup.log
	aws s3 mv $BACKUP_NAME.tar.gz s3://$BUCKET_NAME/
	echo "Backup Transferred to s3 [bucket-name: $BUCKET_NAME]" >> mongodb_backup.log

	## Remove Old Backups ##
	echo "Looking for old backups to remove.." >> mongodb_backup.log
	aws s3 mv s3://$BUCKET_NAME/$OLD_FILENAME.tar.gz old_dump/
	rm -rf old_dump
	echo "old Backup [$OLD_FILENAME.tar.gz] removed" >> mongodb_backup.log
}

if [ ! -f mongodb_backup.lock ];then
        touch mongodb_backup.lock
        mongodb_backup
        rm -rf mongodb_backup.lock
else
        echo "mongodb_backup.lock exists. Plz Check"
fi

