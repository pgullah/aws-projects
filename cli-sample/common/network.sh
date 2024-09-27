#!/usr/bin/env bash
### vpc
# cidr, vpc_name
function _create_vpc() {
    aws ec2 create-vpc --cidr ${1} --tag-specifications "ResourceType=vpc, Tags=[{Key=Name,Value=${2}}]" \
    --query 'Vpc.VpcId' --output text
}

function _get_vpc_id_by_name() {
    aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$1" --query 'Vpcs[*].VpcId'
}

function _get_all_vpc_ids() {
    aws ec2 describe-vpcs --query 'Vpcs[*].VpcId'
}

function _delete_vpc_by_id() {
    echo "Deleting VPC: $1" 
    aws ec2 delete-vpc --vpc-id $1
}

### subnet
# vpcId, cidr_block, az, name
function _create_subnet() {
    aws ec2 create-subnet \
    --vpc-id $1 \
    --cidr-block $2 \
    --availability-zone $3 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$4}]" \
    --query 'Subnet.SubnetId' \
    --output text
}

function _get_all_subnet_ids_by_vpc_id() {
    aws ec2 describe-subnets --filter "Name=vpc-id,Values=$1" --query 'Subnets[*].SubnetId'
}

function _get_subnet_id_by_vpc_id_cidr() {
    aws ec2 describe-subnets --filter "Name=vpc-id,Values=$1" "Name=cidr-block,Values=$2" --query 'Subnets[*].SubnetId'
}

function _delete_subnet_by_id() {
    aws ec2 delete-subnet --subnet-id $1
}

function _delete_all_subnets_by_ids() {
    subnet_ids=( $@ )
    for subnet in "${subnet_ids[@]}"; 
    do
        echo "deleting subnet: $subnet"
        _delete_subnet_by_id $subnet
    done
}

function _delete_all_subnets_by_vpc_id() {    
    _delete_all_subnets_by_ids $(_get_all_subnet_ids_by_vpc_id $1)
}

### internet gateway
function _create_inetgateway() {
    aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$1}]" \
        --query 'InternetGateway.InternetGatewayId' --output text
}

function _update_inetgateway_with_vpc() {
    aws ec2 attach-internet-gateway --internet-gateway-id ${1} --vpc-id ${2}
}

function _get_inetgateway_id_by_name() {
    aws ec2 describe-internet-gateways --filters "Name=tag:Name,Values=$1" --query "InternetGateways[*].InternetGatewayId"
}

function _get_inetgateway_id_by_vpc_id() {
    aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$1" --query "InternetGateways[*].InternetGatewayId"
}

function _delete_inetgateway_by_vpc_id() {
    igateway_id=$(_get_inetgateway_id_by_vpc_id $1)

    [ -z "${igateway_id}" ] && (echo "Unable to find internetGatewayId for vpc:$1"; exit 1;)

    # detach from vpc and then delete
    aws ec2 detach-internet-gateway --internet-gateway-id ${igateway_id} --vpc-id $1
    _delete_igateway_by_id ${igateway_id}
}

function _delete_igateway_by_id() {
    aws ec2 delete-internet-gateway --internet-gateway-id $1
}

### route table

function _create_route_table() {
    aws ec2 create-route-table --vpc-id ${1} \
        --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=${2}}]" \
        --query 'RouteTable.RouteTableId' \
        --output text
}

function _get_all_routetable_ids_vpc_id() {
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$1" --query "RouteTables[*].RouteTableId"
}

function _get_all_routetable_assoc_ids_by_vpc_id() {
    aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$1" --query "RouteTables[*].Associations[*].RouteTableAssociationId"
}

function _get_routetable_id_by_name() {
    aws ec2 describe-route-tables \
        --filters "Name=tag:Name,Values=$1" \
        --query 'RouteTables[*].RouteTableId' \
        --output text
}

function _get_routetable_associations() {
    aws ec2 describe-route-tables \
    --route-table-ids $1 \
    --query 'RouteTables[*].Associations[*].RouteTableAssociationId' \
    --output text
}

function _update_routetable_with_subnet() {
    aws ec2 associate-route-table \
    --route-table-id ${1} \
    --subnet-id ${2}
}

function _delete_routetable_by_vpc_id() {
    rtable_id=$(_get_all_routetable_ids_vpc_id $1)
    _delete_routetable_by_id ${rtable_id}
}

function _delete_routetable_by_name() {
    rtable_id=$(_get_routetable_id_by_name $1)
    _delete_routetable_by_id $rtable_id
}

function _delete_all_routetable_assocs_by_id() {
    rt_assoc_ids=($(_get_routetable_associations $1))
    echo "delete route table associations: ${rt_assoc_ids}"
    for rt_assoc_id in "${rt_assoc_ids[@]}"; 
    do
        aws ec2 disassociate-route-table --association-id ${rt_assoc_id}
    done
}

function _delete_routetable_by_id() {
    aws ec2 delete-route-table --route-table-id $1
}

### route
function _create_route() {
    aws ec2 create-route \
    --route-table-id $1 \
    --destination-cidr-block $2 \
    --gateway-id $3
}

### security group
function _get_security_group_by_name() {
    echo $(aws ec2 describe-security-groups --filters "Name=group-name,Values=$1" --query='SecurityGroups[*].GroupId')
}
# groupid
function _create_securitygroup_with_vpc() {
    aws ec2 create-security-group \
        --group-name ${1} \
        --description "${2}" \
        --vpc-id ${3} \
        --query 'GroupId' \
        --output text
}

function _get_securitygroup_by_name() {
    aws ec2 describe-security-groups \
        --filters "Name=group-name,Values=${1}" \
        --query 'SecurityGroups[*].GroupId' \
        --output text
}

function _update_securitygroup_ingress() {
    aws ec2 authorize-security-group-ingress \
    --group-id $1 \
    --protocol $2 \
    --port $3 \
    --cidr $4
}

function _delete_security_group_by_id() {
    aws ec2 delete-security-group --group-id $1
}

function _delete_security_groups_by_name() {
    security_group_ids=$(_get_security_group_by_name $1)
    for security_group_id in "${security_group_ids[@]}"; do
        aws ec2 delete-security-group --group-id $security_group_id
    done
}