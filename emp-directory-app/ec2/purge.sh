
#! /bin/bash
source ../.includes/instance.sh
source ../.env

${SCRIPT_DIR}/delete-instances.sh
instance_ids="$(_get_instances_by_name ${INSTANCE_NAME})"
# echo $instance_ids
aws ec2 stop-instances --instance-ids ${instance_ids}
# aws ec2 delete-security-group --group-name  ${SECURITY_GROUP}
aws ec2 terminate-instances --instance-ids ${instance_ids}