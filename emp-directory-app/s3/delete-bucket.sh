#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

aws s3api delete-bucket \
    --bucket ${S3_BUCKET_NAME}