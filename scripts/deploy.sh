#!/usr/bin/env bash

OBJECT_KEY=functionCode/$DRONE_REPO_NAME/$DRONE_COMMIT.zip

eval aws lambda update-function-code --function-name $ENVIRONMENT-$DRONE_REPO_NAME --s3-bucket $BUCKET_NAME --s3-key $OBJECT_KEY
ret_code=$?
if [ $ret_code != 0 ]; then
    printf "Error : [%d] when uploading zip to bucket: " $ret_code
    exit $ret_code
fi
echo "Notprod lambda updated with latest code - $ENVIRONMENT-$DRONE_REPO_NAME"
aws lambda publish-version --function-name $ENVIRONMENT-$DRONE_REPO_NAME --description $DRONE_COMMIT
echo "New version published to notprod - $ENVIRONMENT-$DRONE_REPO_NAME $DRONE_COMMIT"
