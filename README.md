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
 
 ## FUTURE  
 * better integration into the makefile
 * additional component review
