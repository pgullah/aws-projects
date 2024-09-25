#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/network.sh
source ${SCRIPT_DIR}/../.includes/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging Ec2 Artifacts ###"

# # delete instances
instance_id=$(_get_ec2_instance_by_name_state ${INSTANCE_NAME} 'running')
if [ -z "${instance_id}" ];
then
    # Instance is not in running state.. tyring to get the instance id of the stopped instance
    instance_id=$(_get_ec2_instance_by_name_state ${INSTANCE_NAME} 'stopped')
else
    aws ec2 stop-instances --instance-ids ${instance_id}
    _wait_for_ec2_instance_state ${instance_id} 'stopped'
fi

aws ec2 terminate-instances --instance-ids ${instance_id}
_wait_for_ec2_instance_state ${instance_id} 'Terminated'
