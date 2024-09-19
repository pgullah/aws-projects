#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

# create security groups
vpc_id=$(_get_vpc_by_name ${VPC_NAME})
aws ec2 create-security-group \
    --group-name ${SECURITY_GROUP} \
    --description "Security group for the web app" \
    --vpc-id ${vpc_id}

# create instances
 # --key-name MyKeyPair \
aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type ${INSTANCE_TYPE} \
    --security-group-ids ${SECURITY_GROUP} \
    --subnet-id ${SUBNET} \
    --count ${INSTANCE_COUNT} \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]"
