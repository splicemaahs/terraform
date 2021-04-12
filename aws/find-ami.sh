#!/usr/bin/env zsh

PROFILE=${AWS_PROFILE:-splice-sales}
LANGUAGE=${1:-German}

OUTPUT=""
#export AMILIST_JQFORMAT='(["NAME","IMAGE_ID","ROOT_DEV_TYPE"] | (., map(length*"-"))), ([.Name, .ImageId, .RootDeviceType]) | @tsv'
for r in us-east-1 us-east-2 us-west-2 eu-west-1 eu-central-1; do
  export AMILIST_JQFORMAT="([\"${r}\", .ImageId, .RootDeviceType, .Name]) | @tsv"
  LINE=$(aws ec2 describe-images --region ${r} --profile ${PROFILE} \
      --owners amazon \
      --filters "Name=platform,Values=windows" "Name=root-device-type,Values=ebs" "Name=name,Values=Windows_Server-2016-${LANGUAGE}-Full-Base*" \
      --query 'sort_by(Images, &CreationDate)[-1]' \
      | jq -r ${AMILIST_JQFORMAT})
  OUTPUT="${OUTPUT}\n${LINE}"
done
for r in us-east-1 us-east-2 us-west-2 eu-west-1 eu-central-1; do
  export AMILIST_JQFORMAT="([\"${r}\", .ImageId, .RootDeviceType, .Name]) | @tsv"
  LINE=$(aws ec2 describe-images --region ${r} --profile ${PROFILE} \
      --owners 125523088429 \
      --filters '[{"Name": "name","Values": ["CentOS 8*"]}, {"Name": "architecture","Values": ["x86_64"]}]' \
      --query 'sort_by(Images, &CreationDate)[-1]' \
      | jq -r ${AMILIST_JQFORMAT})
  OUTPUT="${OUTPUT}\n${LINE}"
done
echo ${OUTPUT}


# CentOS Account ID = 125523088429