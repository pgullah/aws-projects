#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/network.sh
source ${SCRIPT_DIR}/../.includes/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging Ec2 Artifacts ###"

# # delete instances
instance_id=$(_get_ec2_instance_by_name_state ${INSTANCE_NAME} 'running')
aws ec2 stop-instances --instance-ids ${instance_id}
_wait_for_ec2_instance_state ${instance_id} 'Stopped'

aws ec2 terminate-instances --instance-ids ${instance_id}
_wait_for_ec2_instance_state ${instance_id} 'Terminated'
