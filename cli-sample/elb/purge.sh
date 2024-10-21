#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../common/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging ELB artifacts ###"
vpc_id=$(_get_vpc_id_by_name $VPC_NAME)
loadbalancer_arn=$(_get_elb_arn $ELB_NAME)
echo "loadbalancer_arn: ${loadbalancer_arn}"

echo "Delete listeners"
listener_arns=$( aws elbv2 describe-listeners \
    --load-balancer-arn ${loadbalancer_arn} \
    --query 'Listeners[*].ListenerArn' \
    --output text)
aws elbv2 delete-listener --listener-arn ${listener_arns}

echo "delete target group ${ELB_TARGET_GRP}"
target_group_arn=$(aws elbv2 describe-target-groups \
    --load-balancer-arn ${loadbalancer_arn} \
    --query 'TargetGroups[*].TargetGroupArn' \
    --output text)
echo "target_group_arn: $target_group_arn"
aws elbv2 delete-target-group --target-group-arn ${target_group_arn}

# echo "Deleting load balancer"
# aws elbv2 delete-load-balancer --load-balancer-arn ${loadbalancer_arn}

echo "### Purging ELB artifacts finished ###"