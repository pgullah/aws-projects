#! /bin/bash
function _get_vpc_by_name() {
    aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$1" --query 'Vpcs[*].VpcId'
}

function _get_all_vpc_ids() {
    aws ec2 describe-vpcs --query 'Vpcs[*].VpcId'
}

function _get_all_subnets_by_vpc_id() {
    aws ec2 describe-subnets --filter "Name=vpc-id,Values=$1" --query 'Subnets[*].SubnetId'
}

function _get_all_subnets_by_vpc_name() {
    vpc_id = $(_get_vpc_by_name $1)
    _get_all_subnets_by_vpc_id $vpc_id
}

function _get_igateway_by_name() {
    aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=$1" --query "InternetGateways[*].InternetGatewayId"
}

function _get_igateway_by_vpc_id() {
    aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$1" --query "InternetGateways[*].InternetGatewayId"
}

function _get_routetables_vpc_id() {
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$1" --query "RouteTables[*].RouteTableId"
}


function _get_routtable_assoc_by_vpc_id() {
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$1" --query "RouteTables[*].Associations[*].RouteTableAssociationId"
}

function _delete_vpc_by_id() {
    echo "Deleting VPC: $1" 
    aws ec2 delete-vpc --vpc-id $1
}

function _delete_vpc_by_name() {
    _delete_vpc_by_id $(_get_vpc_by_name $1)
}

function _delete_subnet_by_id() {
    aws ec2 delete-subnet --subnet-id $1
}

function _delete_subnets_by_vpc_id() {
    subnet_ids=($(_get_all_subnets_by_vpc_id $1))
    for subnet in "${subnet_ids[@]}"; 
    do
        echo "deleting subnet: $subnet"
        _delete_subnet_by_id $subnet
    done
}

function _delete_igateway_by_vpc_id() {
    igateway_id=$(_get_igateway_by_vpc_id $1)

    # detach from vpc and then delete
    aws ec2 detach-internet-gateway --internet-gateway-id ${igateway_id} --vpc-id $1
    _delete_igateway_by_id ${igateway_id}
}

function _delete_igateway_by_id() {
    aws ec2 delete-internet-gateway --internet-gateway-id $1
}

function _delete_routetable_by_vpc_id() {
    rt_assoc_id=$(_get_routtable_assoc_by_vpc_id $1)
    rtable_id=$(_get_routetables_vpc_id $1)
    echo "rt_assoc_id:$rt_assoc_id"
    echo "rtid:$rtable_id"
    # detach from vpc and then delete
    aws ec2 disassociate-route-table --association-id ${rt_assoc_id}
    _delete_routetable_by_id ${rtable_id}
}

function _delete_routetable_by_id() {
    aws ec2 delete-route-table --route-table-id $1
}