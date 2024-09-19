#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

# create vpc & subnets
aws ec2 create-vpc --cidr ${CIDR_BLOCK_VPC} --tag-specifications "ResourceType=vpc, Tags=[{Key=Name,Value=${VPC_NAME}}]"

# VPC_ID=$(_get_vpc_by_name ${VPC_NAME})
# aws ec2 create-subnet \
#     --vpc-id ${VPC_NAME} \
#     --cidr-block 10.0.1.0/24 \
#     --availability-zone us-east-1a \
#     --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PublicSubnet}]'