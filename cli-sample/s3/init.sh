#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/template.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing S3 Artifacts ###"

policy_json=$(_apply_template ${SCRIPT_DIR}/bucket-policy.json 'ACCOUNT_ID' 'S3_BUCKET_NAME')

# create bucket
aws s3api create-bucket \
    --bucket ${S3_BUCKET_NAME} \
    --region ${DEFAULT_REGION} \
    --create-bucket-configuration LocationConstraint=${DEFAULT_REGION}

# apply policy
aws s3api put-bucket-policy \
    --bucket ${S3_BUCKET_NAME} \
    --policy "${policy_json}"