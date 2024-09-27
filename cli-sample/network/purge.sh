#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../common/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging Network Artifacts ###"

echo "deleting security groups"
_delete_security_groups_by_name ${SECURITY_GROUP}

echo "deleting route table: ${ROUTE_TABLE_NAME} and associations"
rtable_id=$( _get_routetable_id_by_name ${ROUTE_TABLE_NAME})
_delete_all_routetable_assocs_by_id ${rtable_id}
_delete_routetable_by_id ${rtable_id}


vpc_id=$(_get_vpc_id_by_name ${VPC_NAME})
echo "deleting gateway"
_delete_inetgateway_by_vpc_id ${vpc_id}


echo "deleting subnets for VPC: $vpc_id"
_delete_all_subnets_by_vpc_id $vpc_id

echo "deleting vpc"
_delete_vpc_by_id ${vpc_id}
