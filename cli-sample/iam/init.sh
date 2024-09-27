#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "### Initializing roles ###"
${SCRIPT_DIR}/create-roles.sh


