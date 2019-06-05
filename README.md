## Purpose
Scripts to help identify and ameliorate spend in AWS

## Caution
This software is provided as is use at your own risk.

## Functions
### CloudWatch
* Logs
  * How to run
    * Obtain a auth token e.g.`(LOGNAME=USER_NAME_REPLACE_ME AWS_PROFILE=PROFILE_NAME_REPLACE_ME make okta-aws-login)`
    * run the run script e.g. `(AWS_PROFILE=PROFILE_NAME_REPLACE_ME ./run.sh)`
      * if you want the script to automatically remove the unusued log groups prepend with MUTATE=on
  * Use
    * The default run will output an ordered list by incoming bytes
    * You will also see a estimated monthly charge following the incoming bytes to get an understanding of how the billing might break down
    * You will then see the log group name and if you are running in the default non mutating mode it will provide a delete statement for the cases that would  be deleted if you run with mutation on
### Dynamodb
* Tables
  * How to run
    * Obtain a auth token e.g.`(LOGNAME=USER_NAME_REPLACE_ME AWS_PROFILE=PROFILE_NAME_REPLACE_ME make okta-aws-login)`
    * run the run script e.g. `(AWS_PROFILE=PROFILE_NAME_REPLACE_ME ./dynamo_run.sh)`
      * if you want the script to automatically remove the unusued dynamo tables prepend with MUTATE=on
  * Use
    * The default run will output an ordered list by combined read and write consumption for a dynamo table
    * The consumed write
    * The consumed read
    * The dynamo table
    * The suggested delete command if you are in demo mode
### Kinesis
* Stream
  * How to run
    * Obtain a auth token e.g.`(LOGNAME=USER_NAME_REPLACE_ME AWS_PROFILE=PROFILE_NAME_REPLACE_ME make okta-aws-login)`
    * run the run script e.g. `(AWS_PROFILE=PROFILE_NAME_REPLACE_ME ./kinesis_stream_run.sh)`
      * if you want the script to automatically remove the unusued kinesis streams prepend with MUTATE=on
  * Use
    * The default run will output an ordered list by combined read and write consumption for a kinesis stream
    * The consumed write
    * The consumed read
    * The kinesis stream
    * The suggested delete command if you are in demo mode

### S3
* Buckets
  * How to run
    * AWS_PROFILE=PROFILE_NAME_REPLACE_ME ./s3_bucket_sizes.sh
  * Use
    * The default run will output a list of your buckets, size in bytes, and cost per month in dollars

## FUTURE  
* Gemeral
  * better integration into the makefile
  * additional component review
* Dynamo
  * Add provisioned resource checks to suggest provision  adjustments
  * Add review of reserved to suggest appropriate reservations 
* kinesis
  * calculation that takes into account the shards for each stream to provide estimated cost
