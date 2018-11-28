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
        DATASUM=$(aws cloudwatch get-metric-statistics --namespace AWS/Logs --metric-name IncomingBytes --dimensions Name=LogGroupName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Bytes| jq '.Datapoints[0].Sum')
        # DATASUM is in bytes so convert number to GB and then 4 weeks to a month multiplied by the 50 cents a GB price from aws
        let "calculated = (DATASUM /1000000000) * 2"
        echo "${DATASUM}, ${calculated}, ${item}"
        if [[ "${DATASUM}" == "null" ]]
        then
          cleanstring=${item#'"'}
          cleanstring=${cleanstring%'"'}
          $(aws logs delete-log-group --log-group-name ${cleanstring})
        fi
done > tmp_potatoe.txt
sort --field-separator=',' -k1 --numeric-sort tmp_potatoe.txt
