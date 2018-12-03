#!/usr/bin/env bash

#set -x

export PATH ?= /web/tools/bin:/usr/local/bin:/usr/bin:/bin
export AWS_PROFILE ?= put_in_a_thing_here_in_your_shell

REGION ?= us-east-1

MUTATE ?= off

#3600 * 24 * 7
PERIOD=604800
ENDTIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STARTTIME=$(date -u  -v-7d +"%Y-%m-%dT%H:%M:%SZ")
DUMPIT="$(aws dynamodb list-tables| jq '.TableNames[]')"

for item in $DUMPIT
do
    #valuable metrics list
    #https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/monitoring-cloudwatch.html
    #ProvisionedWriteCapacityUnits  --This is how much you indicate dynamo can use
    #ProvisionedReadCapacityUnits -- ditto
    #ConsumedReadCapacityUnits -- This is how much you actuall used
    #ConsumedWriteCapacityUnits -- ditto
    #reference for metrics https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/get-metric-statistics.html
    DATASUMFORREAD=$(aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedReadCapacityUnits --dimensions Name=TableName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Count| jq '.Datapoints[0].Sum')
    DATASUMFORWRITE=$(aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedWriteCapacityUnits --dimensions Name=TableName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Count| jq '.Datapoints[0].Sum')
    calculated=$(echo "$DATASUMFORREAD + $DATASUMFORWRITE"|bc)
    COMMANDSTR=""
    if [[ "${calculated}" == "0" ]]
    then
      cleanstring=${item#'"'}
      cleanstring=${cleanstring%'"'}
      if [[ "${MUTATE}" == "on" ]]
      then
        $(aws dynamodb delete-table --table-name ${cleanstring})
      else
        COMMANDSTR=", aws dynamodb delete-table --table-name ${cleanstring}"
      fi
    fi
    echo "${calculated}, ${DATASUMFORREAD}, ${DATASUMFORWRITE}, ${item}${COMMANDSTR}"
done > tmp_potatoe.txt
sort --field-separator=',' -k1 --numeric-sort tmp_potatoe.txt
