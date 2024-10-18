#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing Networks Artifacts ###"

# create vpc & subnets
echo "creating vpc: $VPC_NAME"
vpc_id=$(_create_vpc ${VPC_CIDR} ${VPC_NAME})

echo "creating gateway: $INET_GATEWAY with vpc: ${vpc_id}"
igatway_id=$(_create_inetgateway $INET_GATEWAY)
_update_inetgateway_with_vpc ${igatway_id} ${vpc_id}

echo "creating route table and associations: ${ROUTE_TABLE_NAME}"
rtable_id=$(_create_route_table ${vpc_id} ${ROUTE_TABLE_NAME})
# Expose access to internet
_create_route ${rtable_id} ${INET_GATEWAY_INGRESS_CIDR} ${igatway_id}

echo "creating subnets"
subnet_zone1_public=$(_create_subnet ${vpc_id} ${SUBNET1_CIDR} ${SUBNET1_AZ} ${SUBNET1_TYPE})
subnet_zone1_private=$(_create_subnet ${vpc_id} ${SUBNET2_CIDR} ${SUBNET2_AZ} ${SUBNET2_TYPE})
subnet_zone2_public=$(_create_subnet ${vpc_id} ${SUBNET3_CIDR} ${SUBNET3_AZ} ${SUBNET3_TYPE})
subnet_zone2_private=$(_create_subnet ${vpc_id} ${SUBNET4_CIDR} ${SUBNET4_AZ} ${SUBNET4_TYPE})

_update_routetable_with_subnet ${rtable_id} ${subnet_zone1_public}
_update_routetable_with_subnet ${rtable_id} ${subnet_zone2_public}

# # ,{Key=attachment.vpc-id,Values=$vpc_id}
echo "creating security group for EC2 instance"
secgroup_id=$(_create_securitygroup_with_vpc ${SECURITY_GROUP} "Security group for the web app" ${vpc_id})
# echo "allow inbound access to ec2 instance"
_update_securitygroup_ingress ${secgroup_id} ${INSTANCE_PROTOCOL} ${INSTANCE_PORT} ${INSTANCE_INGRESS_CIDR}