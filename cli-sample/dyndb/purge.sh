#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

echo "### Purging Dynamo DB Artifacts ###"

echo "Deleting table: ${DYNDB_TBL_NAME} "
aws dynamodb delete-table \
    --table-name ${DYNDB_TBL_NAME} 