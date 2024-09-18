security_group='my-emp-sg'
vpc_id='vpc-123abc45'
aws ec2 create-security-group \
    --group-name ${security_group} \
    --description "Security group for the web app" \
    --vpc-id ${vpc_id}