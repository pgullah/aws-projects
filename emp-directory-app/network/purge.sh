#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.env

${SCRIPT_DIR}/delete-vpc-subnets.sh

# aws ec2 delete-vpc --vpc-id ${VPC_IDS}
# delete vpc/subnets