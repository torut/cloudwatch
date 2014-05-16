#!/bin/bash

source `dirname $0`/../.aws_profile

mysqladmin_cmd=/usr/bin/mysqladmin
mysqladmin_opt="-u [MySQL User] -p[MySQL User Password]"

mysqladmin_status_cmd="${mysqladmin_cmd} ${mysqladmin_opt} status"

thread=`($mysqladmin_status_cmd 2>/dev/null || echo '0 0 0 0') | tr -s ' ' | awk '{print $4}'`

/opt/aws/bin/mon-put-data --metric-name "MySQL Threads" --namespace "MySQL" --dimensions="InstanceId=$instanceid" --value "$thread" --unit "Count"
