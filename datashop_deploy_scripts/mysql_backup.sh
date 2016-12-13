#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

cat << EOM
		+---------------------------------------+
		| This Script will take backup of mysql	|
		| database and store backup file to AWS |
		| s3 bucket [inno-mysql-backups] & also |
		| remove the old backups[before 15 days]|
		|					|
		| 	**Dependencies : awscli		|
		+---------------------------------------+		  
EOM

######## Export aws credentials ########
export AWS_ACCESS_KEY_ID="access_key"
export AWS_SECRET_ACCESS_KEY="secret_key"
export AWS_DEFAULT_REGION="region"
export AWS_DEFAULT_OUTPUT="json"

###### Assign Values ######
TIME=`date +%d-%b-%y`
OLD_TIME=`date +%d-%b-%y --date="15 days ago"`
FILENAME="mysql_backup-$TIME.sql"
OLDFILENAME="mysql_backup-$OLD_TIME.sql"
SRC_DIR="src"
DEST_DIR="dest"
BUCKET_NAME="inno-mysql-backups"

mysql_backup(){

###### Create Backup ######
mkdir -p $DEST_DIR/old_bkp
echo "Taking backup on $TIME" >> mysql_backup.log
mysqldump -u root -proot > $DEST_DIR/$FILENAME
echo "Backup Created" >> mysql_backup.log

###### Transfer Backup to S3 ######
echo "Moving $FILENAME to s3 bucket [ bucketname: "$BUCKET_NAME"]:"
aws s3 mv $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
echo "Backup Transferred to s3" 

###### Remove Old Backups ######
echo "Looking for old backups to remove..." >> mysql_backup.log
#aws s3 mv s3://$BUCKET_NAME/$OLDFILENAME $DEST_DIR/old_bkp/
rm -rf $DEST_DIR/old_bkp
echo "Old backup[filename: "$OLDFILENAME" ] removed" >> mysql_backup.log

echo "Done" >> mysql_backup.log
echo " " >> mysql_backup.log
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* " >> mysql_backup.log
echo " " >> mysql_backup.log

}

if [ ! -f mysql_backup.lock ];then
	touch mysql_backup.lock
	mysql_backup
	rm -rf mysql_backup.lock
else
	echo "mysql_backup.lock exists. Plz Check"
fi
