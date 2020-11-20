#!/usr/bin/env bash

echo  "Uncompressed: $(du -sh lambda_dist/)"
cd lambda_dist

echo "Creating release.zip"
eval zip -r -q release.zip *
ret_code=$?
if [ $ret_code != 0 ]; then
    printf "Error : [%d] when zipping lambda_dist: " $ret_code
    exit $ret_code
fi

echo "Compressed: $(du -sh release.zip)" && cd ..

OBJECT_KEY=$OBJECT_KEY_PREFIX/$DRONE_REPO_NAME/$DRONE_COMMIT.zip
echo "Uploading $DRONE_COMMIT.zip to $OBJECT_KEY_PREFIX/$DRONE_REPO_NAME/"
eval aws s3api put-object --bucket $BUCKET_NAME --key $OBJECT_KEY --body lambda_dist/release.zip --tagging "SHA=$DRONE_COMMIT"
ret_code=$?
if [ $ret_code != 0 ]; then
    printf "Error : [%d] when uploading zip to bucket: " $ret_code
    exit $ret_code
fi