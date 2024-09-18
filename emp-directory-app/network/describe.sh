#!/bin/bash
# utility script to introspect
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

aws ec2 describe-vpcs --output json