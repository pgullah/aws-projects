#! /bin/bash
source .shared/instances.sh
instance_name='my-emp-directory'
security_group='my-emp-sg'

instance_ids="$(_get_instances_by_name ${instance_name})"
echo $instance_ids
aws ec2 stop-instances --instance-ids ${instance_ids}
# aws ec2 delete-security-group --group-name  ${security_group}
aws ec2 terminate-instances --instance-ids ${instance_ids}