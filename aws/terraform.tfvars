aws_region="us-east-1"
aws_profile="splice-pd"
# instance_type="c5a.2xlarge"  # 8vCPU / 16GB instance type
instance_type="m4.xlarge"  # 4vCPU / 16GB instance type
environment="sec_poc"
creator="splicemachine"
# this determines the number of "private" linux boxes that will be generated
windows_machines=[
    "server1"
    "server2",
    "server3"
    # "server4"
]
