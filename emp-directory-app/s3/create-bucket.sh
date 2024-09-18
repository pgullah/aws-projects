#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

aws s3api create-bucket \
    --bucket ${S3_BUCKET_NAME} \
    --region ${DEFAULT_REGION} \
    --create-bucket-configuration LocationConstraint=${DEFAULT_REGION}

