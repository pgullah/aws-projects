#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/template.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing Dynamo DB Artifacts ###"

echo "Creating table: ${DYNDB_TBL_NAME}"
# https://aws.amazon.com/dynamodb/pricing/
# DynamoDB Free Tier Limits
# 25 GB of storage for tables.

# Up to 200 million requests per month split across two types of operations:

# 25 Write Capacity Units (WCUs)
# 25 Read Capacity Units (RCUs)
# 2.5 million stream read requests per month.

# 1 GB of data transfer out between DynamoDB and other AWS services each month.
aws dynamodb create-table \
    --table-name ${DYNDB_TBL_NAME} \
     --attribute-definitions \
        AttributeName=id,AttributeType=S \
    --key-schema \
        AttributeName=id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST