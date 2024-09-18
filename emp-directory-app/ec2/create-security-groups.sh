SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../.includes/vpc.sh
source ${SCRIPT_DIR}/../.env

vpc_id=$(_get_vpc_by_name ${VPC_NAME})
aws ec2 create-security-group \
    --group-name ${SECURITY_GROUP} \
    --description "Security group for the web app" \
    --vpc-id ${vpc_id}