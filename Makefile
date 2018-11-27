.DEFAULT_GOAL = help

export SHELL = /bin/bash
export PATH ?= /web/tools/bin:/usr/local/bin:/usr/bin:/bin
export JAVA_HOME ?= $(shell /usr/libexec/java_home)
#export SBT_OPTS = -Xms6G -Xmx6G -Xss512M

export AWS_PROFILE ?= put_in_a_thing_here_in_your_shell

REGION ?= us-east-1

#3600 * 24 * 7
PERIOD=604800
ENDTIME=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
STARTTIME=$(shell date -u  -v-7d +"%Y-%m-%dT%H:%M:%SZ")
#could not figure out how to invoke this in make task probably something stupid with an escape
LOGGROUP=$(shell aws logs describe-log-groups | jq ".logGroups[] | .logGroupName")

ecr-get-login: ## get the ecr login command
	aws ecr get-login --no-include-email

ecr-login: ## login to ecr
	$$(aws ecr get-login --no-include-email)

okta-aws-login: ## run okta-aws-login (in a separate terminal)
	okta-aws-login --user ${LOGNAME} --region ${REGION} --aws-profile ${AWS_PROFILE} --keep-reloading

find-big-logs:
	#aws logs describe-log-groups | jq '.logGroups[] | .logGroupName' \
	#|xargs -t -I log_group_name_replace_me \
	#aws cloudwatch get-metric-statistics --namespace AWS/Logs --metric-name IncomingBytes --dimensions Name=LogGroupName,Value=log_group_name_replace_me --start-time ${STARTTIME} --end-time ${ENDTIME} --period ${PERIOD} --statistics Sum --unit Bytes 
.PHONY: dist
