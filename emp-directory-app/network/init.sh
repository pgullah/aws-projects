#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

# create vpc & subnets
aws ec2 create-vpc --cidr ${CIDR_BLOCK_VPC} --tag-specifications "ResourceType=vpc, Tags=[{Key=Name,Value=${VPC_NAME}}]"

VPC_ID=$(_get_vpc_by_name ${VPC_NAME})
aws ec2 create-subnet \
    --vpc-id ${VPC_ID} \
    --cidr-block ${SUBNET1_CIDR} \
    --availability-zone ${SUBNET1_AZ} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${SUBNET1_TYPE}}]"
aws ec2 create-subnet \
    --vpc-id ${VPC_ID} \
    --cidr-block ${SUBNET2_CIDR} \
    --availability-zone ${SUBNET2_AZ} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${SUBNET2_TYPE}}]"
aws ec2 create-subnet \
    --vpc-id ${VPC_ID} \
    --cidr-block ${SUBNET3_CIDR} \
    --availability-zone ${SUBNET3_AZ} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${SUBNET3_TYPE}}]"
aws ec2 create-subnet \
    --vpc-id ${VPC_ID} \
    --cidr-block ${SUBNET4_CIDR} \
    --availability-zone ${SUBNET4_AZ} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${SUBNET4_TYPE}}]"


# Create internet gateway
aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$INET_GATEWAY}]"
igatway_id=$(_get_igateway_by_name $INET_GATEWAY)
aws ec2 attach-internet-gateway --internet-gateway-id ${igatway_id} --vpc-id ${VPC_ID}

# ,{Key=attachment.vpc-id,Values=$VPC_ID}