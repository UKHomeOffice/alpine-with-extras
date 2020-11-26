import os
import sys

import boto3
import csv

from scripts.s3_utils import S3Utils

build_row = [
    os.environ.get('DRONE_BUILD_CREATED'),
    os.environ.get('DRONE_BUILD_STATUS'),
    os.environ.get('DRONE_BRANCH'),
    os.environ.get('DRONE_DEPLOY_TO'),
    os.environ.get('DRONE_BUILD_EVENT'),
    os.environ.get('DRONE_BUILD_NUMBER'),
    os.environ.get('DRONE_BUILD_PARENT'),
    os.environ.get('DRONE_COMMIT_SHA'),
    os.environ.get('DRONE_COMMIT_AUTHOR_EMAIL'),
    os.environ.get('DRONE_COMMIT_AUTHOR_NAME'),
]


class DeploymentChecker:

    def __init__(self, s3_utils, repo_name):
        self._s3_utils = s3_utils
        self._repo_name = repo_name

    def save_build_info_to_csv(self, build_row):
        self._s3_utils.load_from_s3(self._repo_name, 'build.csv', fail_on_not_found=False)
        with open('build.csv', 'a') as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow(build_row)
        self._s3_utils.save_to_s3('build.csv', self._repo_name)


if __name__ == '__main__':
    utils = S3Utils(os.environ['BUCKET_NAME'])
    repo = os.environ['DRONE_REPO']
    checker = DeploymentChecker(utils, repo)
    #print(utils.delete_from_s3(repo))
    checker.save_build_info_to_csv(build_row)
