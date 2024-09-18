#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/instance.sh
source ${SCRIPT_DIR}/../.env

${SCRIPT_DIR}/delete-instances.sh