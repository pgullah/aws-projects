#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../common/network.sh
source ${SCRIPT_DIR}/../common/ec2.sh
source ${SCRIPT_DIR}/../.env

echo "### Purging Lambda Artifacts ###"
