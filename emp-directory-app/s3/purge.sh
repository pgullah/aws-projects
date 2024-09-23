#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

echo "### Purging S3 Artifacts ###"

# delete bucket
aws s3api delete-bucket --bucket ${S3_BUCKET_NAME}