#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

# delete vpc and subnets
vpc_id=$(_get_vpc_by_name ${VPC_NAME})
echo $vpc_id
_delete_vpc_by_id ${vpc_id}