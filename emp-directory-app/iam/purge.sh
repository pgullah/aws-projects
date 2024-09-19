#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

# detach polices and delete role
echo "Detaching policies for the role: ${ROLE_NAME}"
aws iam remove-role-from-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME} --role-name ${ROLE_NAME}
for policy_arn in ${ROLE_POLICY_ARNS[@]}; do
    aws iam detach-role-policy --role-name ${ROLE_NAME} --policy-arn ${policy_arn}
done

echo "Deleteing role: ${ROLE_NAME}"
aws iam delete-role --role-name ${ROLE_NAME}

echo "Deleteing instance profile: ${EC2_INSTANCE_PROFILE_NAME}"
aws iam delete-instance-profile --instance-profile-name ${EC2_INSTANCE_PROFILE_NAME}
