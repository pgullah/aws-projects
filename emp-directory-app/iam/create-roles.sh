#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

aws iam create-role ${ROLE_NAME} --assume-role-policy-document 

aws iam create-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME}
# attach role to instance profile
aws iam add-role-to-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME} --role-name ${ROLE_NAME}