#!/bin/bash

source `dirname $0`/../.aws_profile

nginx_status_url=http://localhost/status

active_connection=`curl -s ${nginx_status_url} | tr "\n" ";" | tr -s ' ' | awk -F\; '{print $1 };' | awk '{ print $3 }'`

/opt/aws/bin/mon-put-data --metric-name "Nginx Active connections" --namespace "Nginx" --dimensions="InstanceId=$instanceid" --value "$active_connection" --unit "Count"
