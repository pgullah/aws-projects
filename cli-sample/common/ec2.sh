function _get_instances_by_name() {
    echo $(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" --query 'Reservations[*].Instances[*].InstanceId')
}

function _get_ec2_instance_by_name_state() {
    echo $(aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=$2" --query 'Reservations[*].Instances[*].InstanceId')
}

function _get_ec2_instance_state() {
    # this doesn't return status when the instance stopped or terminated so utilizing ec2 describe-instances instead
    # echo $(aws ec2 describe-instance-status --instance-id $1 --query "InstanceStatuses[*].InstanceState.Name")
    aws ec2 describe-instances --instance-ids $1 --query 'Reservations[*].Instances[*].State.Name'
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

function _wait_for_ec2_instance_state() {
    instance_id=$1
    target_state=$2
    # defaults to 1 sec delay
    sleep_delay=${3:-5}
    timeout=${4:-180}
    SECONDS=0
    # [ -z $instance_id ] && echo 'Please specify instanceId'; return 1;
    # [ -z $target_state ] && echo 'Please specify the target state'; return 1;

    # current_state=$(_get_ec2_instance_state $instance_id)
    # echo ">>>>>>>>>> current_state: $current_state and target state: ${target_state}"
    while [ "${current_state,,}" != "${target_state,,}" ];
    do
        if (( $SECONDS > $timeout ));
        then
            echo "Timeout occurred while waiting for instance state to be ${target_state}!"
            break
        else
            echo "waiting for instance:$instance_id state to be ${target_state}"
            sleep ${sleep_delay}
            current_state=$(_get_ec2_instance_state $instance_id)
            # echo ">>>>>>>>>> current_state: $current_state and target state: ${target_state}"
        fi
    done
}