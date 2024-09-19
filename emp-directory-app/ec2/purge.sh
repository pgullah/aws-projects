#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/instance.sh
source ${SCRIPT_DIR}/../.env

# delete instances
instance_ids="$(_get_instances_by_name ${instance_name})"
# echo $instance_ids
aws ec2 stop-instances --instance-ids ${instance_ids}
# aws ec2 delete-security-group --group-name  ${security_group}
aws ec2 terminate-instances --instance-ids ${instance_ids}

# delete security groups
