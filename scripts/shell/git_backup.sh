#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

set -e

######## Export aws credentials ########

export AWS_ACCESS_KEY_ID="access_key"
export AWS_SECRET_ACCESS_KEY="secret_access_key"
export AWS_DEFAULT_REGION="region"
export AWS_DEFAULT_OUTPUT="json"

###############################################

TIME=`date +%d-%b-%y`
FILENAME="backup-$TIME.tar.gz"
SRC_DIR="src"
DEST_DIR="dest"
BUCKET_NAME="innovaccer-git-backup"

backup(){
echo "Taking backup on $TIME"
echo "tar -cpzf $DEST_DIR/$FILENAME $SRC_DIR"
echo "Backup Created"

echo "Moving $FILENAME to s3"
aws s3 mv $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
echo "Backup Transferred to s3" 
}

backup
