#!/usr/bin/env bash
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function _get_or_default() {
    var=$1
    if [ -z ${var+x} ]; 
    then
        echo "$2"
    else 
        echo "$var"
    fi
}

function _choose_if() {
    [[ "$1" = "$2" ]] && echo $3 || echo $4
}