#!/bin/bash

export AWS_CREDENTIAL_FILE=[Credential File Path]
export AWS_REGION=[Region]
mysqladmin_cmd=/usr/bin/mysqladmin
mysqladmin_opt="-u [MySQL User] -p[MySQL User Password]"

export JAVA_HOME=/usr/lib/jvm/jre
export AWS_CLOUDWATCH_HOME=/opt/aws/apitools/mon
export AWS_CLOUDWATCH_URL=https://monitoring.${AWS_REGION}.amazonaws.com
export PATH=$PATH:$HOME/bin:$AWS_CLOUDWATCH_HOME/bin
instanceid=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

mysqladmin_status_cmd="${mysqladmin_cmd} ${mysqladmin_opt} status"

thread=`($mysqladmin_status_cmd 2>/dev/null || echo '0 0 0 0') | tr -s ' ' | awk '{print $4}'`

/opt/aws/bin/mon-put-data --metric-name "MySQL Threads" --namespace "MySQL" --dimensions="InstanceId=$instanceid" --value "$thread" --unit "Count"
