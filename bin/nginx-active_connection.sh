#!/bin/bash

export AWS_CREDENTIAL_FILE=[Credential File Path]
export AWS_REGION=[Region]
nginx_status_url=http://localhost/status

export JAVA_HOME=/usr/lib/jvm/jre
export AWS_CLOUDWATCH_HOME=/opt/aws/apitools/mon
export AWS_CLOUDWATCH_URL=https://monitoring.${AWS_REGION}.amazonaws.com
export PATH=$PATH:$HOME/bin:$AWS_CLOUDWATCH_HOME/bin
instanceid=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

active_connection=`curl -s ${nginx_status_url} | tr "\n" ";" | tr -s ' ' | awk -F\; '{print $1 };' | awk '{ print $3 }'`

/opt/aws/bin/mon-put-data --metric-name "Nginx Active connections" --namespace "Nginx" --dimensions="InstanceId=$instanceid" --value "$active_connection" --unit "Count"
