import os
import boto3
from botocore.config import Config
from botocore.exceptions import ClientError


class S3Utils:

    def __init__(self, bucket_name):
        self._s3 = boto3.client('s3', config=Config(signature_version='s3v4'))
        self._bucket_name = bucket_name
        self._kms_args = {'ServerSideEncryption': 'aws:kms',
                          'SSEKMSKeyId': os.environ['KMS_KEY_ID']
                          }

    def list_files_s3(self):
        result = self._s3.list_objects_v2(Bucket=self._bucket_name)
        if 'Contents' in result:
            return [obj['Key'] for obj in result['Contents']]
        else:
            return []

    def save_to_s3(self, file_name, key_name):
        self._s3.upload_file(file_name, self._bucket_name, key_name, ExtraArgs=self._kms_args)

    def load_from_s3(self, key_name, file_name, fail_on_not_found=True):
        try:
            self._s3.download_file(self._bucket_name, key_name, file_name)
        except ClientError as err:
            if not fail_on_not_found and err.response['Error']['Code'] == '404':
                print(f'{key_name} not found in S3 bucket {self._bucket_name}')
            else:
                raise err

    def delete_from_s3(self, key_name):
        return self._s3.delete_object(Bucket=self._bucket_name, Key=key_name)['DeleteMarker']
