SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

 # --key-name MyKeyPair \
aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type ${INSTANCE_TYPE} \
    --security-group-ids ${SECURITY_GROUP} \
    --subnet-id ${SUBNET} \
    --count ${INSTANCE_COUNT} \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]"
