#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

set -e

######## Export aws credentials ########

export AWS_ACCESS_KEY_ID="access_key"
export AWS_SECRET_ACCESS_KEY="secret_KEY"
export AWS_DEFAULT_REGION="region"
export AWS_DEFAULT_OUTPUT="json"

###############################################

TIME=`date +%d-%b-%y`
OLD_TIME=`date +%d-%b-%y --date="15 days ago"`
FILENAME="backup-$TIME.tar.gz"
OLDFILENAME="backup-$OLD_TIME.tar.gz"
SRC_DIR="src"
DEST_DIR="dest"
BUCKET_NAME="innovaccer-git-backup"

backup(){

###### Create Backup ######
mkdir -p old_bkp
echo "Taking backup on $TIME"
echo "tar -cpzf $DEST_DIR/$FILENAME $SRC_DIR"
echo "Backup Created"

###### Transfer Backup to S3 ######
echo "Moving $FILENAME to s3"
aws s3 mv $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
echo "Backup Transferred to s3" 

###### Remove Old Backups ######
echo "Removing old backups"
aws s3 mv s3://$BUCKET_NAME/$OLDFILENAME old_bkp/
rm -rf old_bkp

echo "Done..!!!"
}

backup
