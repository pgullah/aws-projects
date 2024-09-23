#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/network.sh
source ${SCRIPT_DIR}/../.includes/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging Ec2 Artifacts ###"

# # delete instances
instance_ids=($(_get_instances_by_name ${INSTANCE_NAME}))
echo $instance_ids
for inst_id in "${instance_ids[@]}";
do
    instance_state= $(_get_ec2_instance_state $inst_id)
    echo "instance_state: $instance_state"
    if [ "${instance_state}" == 'running' ]; 
    then
        aws ec2 stop-instances --instance-ids ${instance_ids}
        # aws ec2 delete-security-group --group-name  ${security_group}
        aws ec2 terminate-instances --instance-ids ${instance_ids}
    else
        echo "Instance $inst_id with status: $instance_state can't be stopped"
    fi
done

# delete security groups
_delete_ec2_security_groups_by_name ${SECURITY_GROUP}
