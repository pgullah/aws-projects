
# applies template with the variable and emits text
function _apply_template() {
    template_file=$1
    shift 1
    sed "$(__build_sed_command $@)" $template_file
}

function __build_sed_command() {
    sed_command=""
    for tmpl_variable in "$@"; do
        value="${!tmpl_variable}"
        sed_command+="s;%%$tmpl_variable%%;$value;g;"
    done
    echo $sed_command
}

# generates new file from template
function _apply_template_generate_file() {
    template_file=$1
    shift 1
    temp_file=$(mktemp)
    cp $template_file $temp_file
    sed -i "$(__build_sed_command $@)" $temp_file
    echo $temp_file
}

function _close_on_exit() {
    rm -f "$1"
}
# _apply_template ${SCRIPT_DIR}/bucket-policy.json 'ACCOUNT_ID'