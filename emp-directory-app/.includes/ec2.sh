function _get_instances_by_name() {
    echo $(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" --query 'Reservations[*].Instances[*].InstanceId')
}

function _get_ec2_instance_state() {
    echo $(aws ec2 describe-instance-status --instance-id $1 --query "InstanceStatuses[*].InstanceState.Name")
}

# IMAGE_ID, INSTANCE_TYPE, SECURITY_GROUP, SUBNET1_CIDR, INSTANCE_COUNT, INSTANCE_NAME, user_data
function _create_ec2_instance() {
    # instance_id=$(_get_instances_by_name $6)
    echo $(aws ec2 run-instances \
    --image-id $1 \
    --instance-type $2 \
    --security-group-ids $3 \
    --subnet-id $4 \
    --count $5 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$6}]" \
    --user-data $7 \
    --query 'Instances[0].InstanceId' --output text)
}

function _get_security_group_by_name() {
    echo $(aws ec2 describe-security-groups --filters "Name=group-name,Values=$1" --query='SecurityGroups[*].GroupId')
}


# groupid
function _delete_ec2_security_group_by_id() {
    aws ec2 delete-security-group --group-id $1
}

function _delete_ec2_security_groups_by_name() {
    security_group_ids=$(_get_security_group_by_name $1)
    for security_group_id in "${security_group_ids[@]}"; do
        aws ec2 delete-security-group --group-id $security_group_id
    done
}