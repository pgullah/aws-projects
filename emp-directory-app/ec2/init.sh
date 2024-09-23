#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/network.sh
source ${SCRIPT_DIR}/../.includes/template.sh
source ${SCRIPT_DIR}/../.includes/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing EC2 Artifacts ###"

# create security groups
vpc_id=$(_get_vpc_by_name ${VPC_NAME})
aws ec2 create-security-group \
    --group-name ${SECURITY_GROUP} \
    --description "Security group for the web app" \
    --vpc-id ${vpc_id}

user_data=$(_apply_template ${SCRIPT_DIR}/user-data.txt 'S3_BUCKET_NAME' 'DEFAULT_REGION')
# create instances
 # --key-name MyKeyPair \
security_group_id=$(_get_security_group_by_name ${SECURITY_GROUP})
subnet_id=$(_get_subnet_by_vpc_id_cidr ${vpc_id} ${SUBNET1_CIDR})
echo "Creating EC2 instance" 
instance_id=$(aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type ${INSTANCE_TYPE} \
    --security-group-ids ${security_group_id} \
    --subnet-id "${subnet_id}" \
    --count ${INSTANCE_COUNT} \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]" \
    --user-data "${user_data}" --query 'Instances[0].InstanceId' --output text)

while [ "${instance_state}" != 'running' ];
do
    echo "waiting for instance to be up"
    sleep 1
    instance_state=$(_get_ec2_instance_state $instance_id)
done
