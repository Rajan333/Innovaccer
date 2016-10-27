#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

### Dependenies ###
# awscli
 
set -e

######## Export aws credentials ########

export AWS_ACCESS_KEY_ID="AKIAJMCRFJFK7E5P6DWQ"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-west-2"
export AWS_DEFAULT_OUTPUT="json"

###############################################

TIME=`date +%d-%b-%y`
OLD_TIME=`date +%d-%b-%y --date="15 days ago"`
FILENAME="git-backup-$TIME.tar.gz"
OLDFILENAME="git-backup-$OLD_TIME.tar.gz"
SRC_DIR="/mnt/gitlab-repositories/repositories"
DEST_DIR="/mnt/gitlab-repositories/git-bkp"
BUCKET_NAME="inno-git-backup"

backup(){

####### Change Permission ####
sudo chmod -R o+rwx $SRC_DIR

###### Create Backup ######
mkdir -p old_bkp $DEST_DIR
echo "Backup Initiated on $TIME" >> git_backup.log
tar -cpzf $DEST_DIR/$FILENAME $SRC_DIR
echo "Backup Created" >> git_backup.log
echo "Backup FileName: $FILENAME" >> git_backup.log

###### Transfer Backup to S3 #####
echo "Moving backup file ["$FILENAME"] to s3 [ bucket name: "$BUCKET_NAME" ]" >> git_backup.log
aws s3 mv $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
#aws s3 cp $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
echo "Backup Transferred to s3-bucket" >> git_backup.log

###### Remove Old Backups ######
echo "Looking for old backups backups to remove..." >> git_backup.log
echo "old backup file: $OLDFILENAME"
aws s3 mv s3://$BUCKET_NAME/$OLDFILENAME old_bkp/
rm -rf old_bkp
echo "Old backup[filename: $OLDFILENAME ] removed" >> git_backup.log

###### Send notification mail for process update ######
echo "Backup Process Completed Successfully...!!!" | mail -s "Backup Process" rajan.middha@innovaccer.com

sudo chmod -R o-rwx $SRC_DIR  ### Change to previous permissions

echo "Done..!!!" >> git_backup.log
echo " " >> git_backup.log
echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* " >> git_backup.log
echo " " >> git_backup.log

}

if [ ! -f backup.lock ];then
	touch backup.lock
	backup
	rm -rf backup.lock
else
	echo "backup.lock exists. Plz Check"
fi
