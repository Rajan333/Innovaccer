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
FILENAME="backup-$TIME.tar.gz"
OLDFILENAME="backup-$OLD_TIME.tar.gz"
SRC_DIR="/mnt/gitlab-repositories"
DEST_DIR="/home/rajan_middha"
BUCKET_NAME="innovaccer-git-backup"

backup(){

###### Create Backup ######
mkdir -p old_bkp
echo "Taking backup on $TIME"
tar -cpzf $DEST_DIR/$FILENAME $SRC_DIR
echo "Backup Created"

###### Transfer Backup to S3 ######
echo "Moving $FILENAME to s3"
aws s3 mv $DEST_DIR/$FILENAME s3://$BUCKET_NAME/$FILENAME
echo "Backup Transferred to s3" 

###### Remove Old Backups ######
echo "Removing old backups"
aws s3 mv s3://$BUCKET_NAME/$OLDFILENAME old_bkp/
rm -rf old_bkp

###### Send notification mail for process update ######
echo "Backup Process Completed Successfully...!!!" | mail -s "Backup Process" rajan.middha@innovaccer.com

echo "Done..!!!"
}
}

backup
