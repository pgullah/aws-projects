#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

aws iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document "file://${SCRIPT_DIR}/ec2-trust-policy.json"
aws iam create-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME}
# attach role to instance profile
aws iam add-role-to-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME} --role-name ${ROLE_NAME}
for policy_arn in ${ROLE_POLICY_ARNS[@]}; do
    aws iam attach-role-policy --role-name ${ROLE_NAME} --policy-arn ${policy_arn}
done