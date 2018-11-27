#!/usr/bin/env bash

#set -x

export PATH ?= /web/tools/bin:/usr/local/bin:/usr/bin:/bin
export AWS_PROFILE ?= put_in_a_thing_here_in_your_shell

REGION ?= us-east-1

#3600 * 24 * 7
PERIOD=604800
ENDTIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STARTTIME=$(date -u  -v-7d +"%Y-%m-%dT%H:%M:%SZ")
#could not figure out how to invoke this in make task probably something stupid with an escape
LOGGROUP="$(aws logs describe-log-groups | jq '.logGroups[] | .logGroupName')"


for item in $LOGGROUP
do
        echo "Item: $item"
        aws cloudwatch get-metric-statistics --namespace AWS/Logs --metric-name IncomingBytes --dimensions Name=LogGroupName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Bytes
done
