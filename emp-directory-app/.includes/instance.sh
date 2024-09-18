function _get_instances_by_name() {
    echo $(aws ec2 describe-vpc --filters "Name=tag:Name,Values=$1" --query 'Reservations[*].Instances[*].InstanceId')
}

