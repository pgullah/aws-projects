#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/network.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing Networks Artifacts ###"

# create vpc & subnets
_create_vpc ${VPC_CIDR} ${VPC_NAME}
# aws ec2 create-vpc --cidr ${VPC_CIDR} --tag-specifications "ResourceType=vpc, Tags=[{Key=Name,Value=${VPC_NAME}}]"

vpc_id=$(_get_vpc_by_name ${VPC_NAME})
_create_subnet ${vpc_id} ${SUBNET1_CIDR} ${SUBNET1_AZ} ${SUBNET1_TYPE}
_create_subnet ${vpc_id} ${SUBNET2_CIDR} ${SUBNET2_AZ} ${SUBNET2_TYPE}
_create_subnet ${vpc_id} ${SUBNET3_CIDR} ${SUBNET3_AZ} ${SUBNET3_TYPE}
_create_subnet ${vpc_id} ${SUBNET4_CIDR} ${SUBNET4_AZ} ${SUBNET4_TYPE}


# Create internet gateway
aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$INET_GATEWAY}]"
igatway_id=$(_get_igateway_by_name $INET_GATEWAY)
aws ec2 attach-internet-gateway --internet-gateway-id ${igatway_id} --vpc-id ${vpc_id}

# ,{Key=attachment.vpc-id,Values=$vpc_id}
aws ec2 create-security-group \
    --group-name ${SECURITY_GROUP} \
    --description "Security group for the web app" \
    --vpc-id ${vpc_id}