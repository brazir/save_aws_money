#!/usr/bin/env bash

#set -x

export PATH ?= /web/tools/bin:/usr/local/bin:/usr/bin:/bin
export AWS_PROFILE ?= put_in_a_thing_here_in_your_shell

REGION ?= us-east-1

#3600 * 24 * 7
PERIOD=604800
ENDTIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STARTTIME=$(date -u  -v-7d +"%Y-%m-%dT%H:%M:%SZ")
DUMPIT="$(aws s3api list-buckets|jq '.Buckets[].Name')"

for item in $DUMPIT
do
    #Dimensions are filters so we are filtering to get information about a specific bucket for any bucket that uses standard storage the most expensive form of storage
    DATA=$(aws cloudwatch get-metric-statistics --namespace AWS/S3 --metric-name BucketSizeBytes --dimensions Name=BucketName,Value=${item} Name=StorageType,Value=StandardStorage --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Average --unit Bytes| jq '.Datapoints[0].Average')
    CALCULATE=$(echo "($DATA / 1000000000) * 0.023"|bc)
    echo "${item}, ${DATA}, $CALCULATE"
done > tmp_potatoe.txt
sort --field-separator=',' -k2 --numeric-sort tmp_potatoe.txt
