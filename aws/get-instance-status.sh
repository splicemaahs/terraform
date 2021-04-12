#!/usr/bin/env bash

PROFILE=${AWS_PROFILE:-splice-nonprod}

INSTANCE_ID=${1}
REGION=${2:-us-east-1}

aws ec2 describe-instances --region ${REGION} --profile ${PROFILE} --instance-ids ${INSTANCE_ID} | jq -r '.Reservations[].Instances[].State.Name'

