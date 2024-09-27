#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/base.sh
source ${SCRIPT_DIR}/../common/template.sh
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../common/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing EC2 Artifacts ###"

# create security groups
vpc_id=$(_get_vpc_id_by_name ${VPC_NAME})

user_data=$(_apply_template ${SCRIPT_DIR}/user-data.txt 'S3_BUCKET_NAME' 'DEFAULT_REGION' 'INSTANCE_PORT')
# create instances
 # --key-name MyKeyPair \
security_group_id=$(_get_security_group_by_name ${SECURITY_GROUP})
subnet_id=$(_get_subnet_id_by_vpc_id_cidr ${vpc_id} ${SUBNET1_CIDR})
associate_public_ip_flag=$(_choose_if "${ENABLE_INSTANCE_PUBLIC_IP}" 'true' '--associate-public-ip-address' '--no-associate-public-ip-address')

echo "Creating EC2 instance" 
instance_id=$(aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type ${INSTANCE_TYPE} \
    --iam-instance-profile Name=${EC2_INSTANCE_PROFILE_NAME} \
    --security-group-ids ${security_group_id} \
    --subnet-id "${subnet_id}" \
    --count ${INSTANCE_COUNT} \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]" \
    --user-data "${user_data}" --query 'Instances[0].InstanceId' \
    ${associate_public_ip_flag} \
     --output text)

_wait_for_ec2_instance_state ${instance_id} 'running'

echo "Instance started successfully!"
