#! /bin/bash
instance_name='my-emp-directory'
VPC='vpc'
SUBNET='subnet-6789def0'
security_group='my-emp-sg'
SUB_PHOTOS_BUCKET="my-emp-bucket-123"
IMAGE_ID='ami-1234567890abcdef0'
INSTANCE_TYPE='t2.micro'

aws ec2 run-instances \
    --image-id ${IMAGE_ID} \
    --instance-type t2.micro \
    --key-name MyKeyPair \
    --security-group-ids ${security_group} \
    --subnet-id ${SUBNET} \
    --count 1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${instance_name}}]"
