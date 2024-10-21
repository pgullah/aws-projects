#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../common/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Initializing Elastic load balancer Artifacts ###"



echo "create target group ${ELB_TARGET_GRP}"
vpc_id=$(_get_vpc_id_by_name $VPC_NAME)
target_group_arn=$(aws elbv2 create-target-group \
    --name ${ELB_TARGET_GRP} \
    --protocol HTTP \
    --port ${INSTANCE_PORT} \
    --vpc-id ${vpc_id} \
    --target-type instance \
    --query 'TargetGroups[0].TargetGroupArn' --output text )

echo "Creating elastic load balancer: ${ELB_NAME}"
subnet_zone1_public=$(_get_subnet_id_by_vpc_id_cidr ${vpc_id} ${SUBNET1_CIDR})
subnet_zone2_public=$(_get_subnet_id_by_vpc_id_cidr ${vpc_id} ${SUBNET3_CIDR})
security_group_id=$(_get_security_group_by_name ${SECURITY_GROUP})

loadbalancer_arn=$(aws elbv2 create-load-balancer \
    --name ${ELB_NAME} \
    --subnets ${subnet_zone1_public} ${subnet_zone2_public} \
    --security-groups ${security_group_id} \
    --scheme internet-facing \
    --type application \
    --query 'LoadBalancers[0].LoadBalancerArn' --output text )

echo "Register targets to ELB"
instance_ids=$(_get_ec2_instance_by_name_state ${INSTANCE_NAME} 'running')
echo "instance_ids: ${instance_ids}"
target_instances=''
for instance_id in ${instance_ids[@]};
do
    target_instances="${target_instances} Id=${instance_id}"
done
# echo "target_instances: ${target_instances}"
aws elbv2 register-targets \
    --target-group-arn ${target_group_arn} \
    --targets ${target_instances}

echo "Creating listeners"
aws elbv2 create-listener \
    --load-balancer-arn ${loadbalancer_arn} \
    --protocol HTTP \
    --port ${INSTANCE_PORT} \
    --default-actions Type=forward,TargetGroupArn=${target_group_arn}

_wait_for_elb_state ${ELB_NAME} 'active'

echo "### Finished initializing Elastic load balancer Artifacts ###"