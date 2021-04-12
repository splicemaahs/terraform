#!/usr/bin/env bash

PROFILE=${AWS_PROFILE:-splice-nonprod}

INSTANCE_ID=${1}
REGION=${2:-us-east-1}
aws ec2 get-password-data --region ${REGION} --profile ${PROFILE} --instance-id ${INSTANCE_ID} --priv-launch-key ./winkey | jq -r '.PasswordData' | tee >(pbcopy)
