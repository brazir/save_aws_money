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
DUMPIT="$(aws kinesis list-streams| jq '.StreamNames[]')"

for item in $DUMPIT
do
    DATASUMFORREAD=$(aws cloudwatch get-metric-statistics --namespace AWS/Kinesis --metric-name GetRecords.Bytes --dimensions Name=StreamName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Bytes| jq '.Datapoints[0].Sum')
    DATASUMFORWRITE=$(aws cloudwatch get-metric-statistics --namespace AWS/Kinesis --metric-name PutRecords.Bytes --dimensions Name=StreamName,Value=${item} --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Bytes| jq '.Datapoints[0].Sum')
    calculated=$(echo "$DATASUMFORREAD + $DATASUMFORWRITE"|bc)
    COMMANDSTR=""
    if [[ "${calculated}" == "0" ]]
    then
      cleanstring=${item#'"'}
      cleanstring=${cleanstring%'"'}
      if [[ "${MUTATE}" == "on" ]]
      then
        $(aws kinesis delete-stream --stream-name ${cleanstring})
      else
        COMMANDSTR=", aws kinesis delete-stream --stream-name ${cleanstring}"
      fi
    fi
    echo "${calculated}, ${DATASUMFORREAD}, ${DATASUMFORWRITE}, ${item}${COMMANDSTR}"
done > tmp_potatoe.txt
sort --field-separator=',' -k1 --numeric-sort tmp_potatoe.txt
