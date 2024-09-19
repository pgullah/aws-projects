#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

# delete vpc and subnets
vpc_id=$(_get_vpc_by_name ${VPC_NAME})
echo "VPC ID: $vpc_id"
_delete_subnets_by_vpc_id $vpc_id
_delete_igateway_by_vpc_id ${vpc_id}
_delete_vpc_by_id ${vpc_id}
