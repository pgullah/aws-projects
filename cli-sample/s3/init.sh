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

# remove public access block
# https://docs.aws.amazon.com/cli/latest/reference/s3api/delete-public-access-block.html
# https://eu-west-2.console.aws.amazon.com/s3/settings?region=eu-west-2&bucketType=general
# aws s3api put-public-access-block \
#     --bucket ${S3_BUCKET_NAME} \
#     --public-access-block-configuration BlockPublicPolicy=false,IgnorePublicAcls=false
aws s3api delete-public-access-block --bucket ${S3_BUCKET_NAME}

# apply policy
aws s3api put-bucket-policy \
    --bucket ${S3_BUCKET_NAME} \
    --policy "${policy_json}"