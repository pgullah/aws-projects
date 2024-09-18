#! /bin/bash
role_name=S3DynamoDBFullAccessRole
inst_prof_name=S3DynamoDBFullAccessRole
aws iam create-instance-profile --instance-profile-name ${inst_prof_name}
# attach role to instance profile
aws iam add-role-to-instance-profile --instance-profile-name ${inst_prof_name} --role-name ${role_name}