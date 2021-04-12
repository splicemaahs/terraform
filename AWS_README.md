# Use Terraform to build an environment for testing SEC POC

Start from the `./aws` directory.

This creates a network of Windows Machines, you can RDP into the Jumpbox, and the
jumpbox itself has Internet access.  The Server 1 .. Server N machines have no
internet access, making the environment similar to what we can expect inside the
air-gapped facility.  We can download files onto the jumpbox, transfer them to
the Server machines for installation.  If we build AMIs for the individual servers
that contain already installed software, we can extend this to spin up each of the
isolated servers with a specific AMI, for now they are spinning up with the
original Windows 10 image that Brandon made.

```plaintext
                                            No Internet
+--------+         +---------+            +------------+
|        |         |         |            |            |
|  You   |<-pubIp->| Jumpbox |<--privIp-->|  Server 1  |
|        |         |         |            |            |
+--------+         +---------+            +------------+
                                                ˄
                                                |
                                                | Private network
                                                |
                                                ˅
                                          +------------+
                                          |            |
                                          |  Server N  |
                                          |            |
                                          +------------+
```

## Edit terraform.tfvars

Set the environmentname and creator to something unique to spin up your own environment

The AMI we are using only exists in us-east-1, so we will need to stay there at the moment.

```conf
aws_region="us-east-1"
aws_profile="splice-pd"
# instance_type="c5a.2xlarge"  # 8vCPU / 16GB instance type
instance_type="m4.xlarge"  # 4vCPU / 16GB instance type
environment="sec_poc"
creator="splicemachine"
# this determines the number of "private" windows boxes that will be generated
windows_machines=[
    "server1"
    "server2",
    "server3"
    # "server4"
]
```

## Run Terraform

Ensure that you have authenticated with MFA before running Terraform or it will
appear to hang.

```bash
terraform init
terraform plan
terraform apply
```

The `terraform apply` will output the public/private IP addresses and the instance_ids.

### Wait for instance to become "running"

```bash
./get-instance-status.sh <instance_id> <region>
```

### RDP to the Jumpbox instance

Use "Microsoft Remote Desktop" from the App Store, or other RDP client to connect
to the instance using the public IP, `Administrator` user, and the password acquired
from the `get-windows-password.sh` command.

From the Jumpbox, you can run `mstsc` and then RDP using the Private IP address of the
other internal windows machine.  You will need to extract the password for this internal
machine in the same way as was done for the Jumpbox.

### Disable Enhanced IE Security

Click the Windows button
Run: Server Manager
On the left, choose "Local Server"
On the right, IE Enhanced Security Configuration, click "On"
Set to "Off" for both Administrators and Users

## Terraform Destroy

When you are completely done, run the following from the same directory
you ran the `terraform apply` from.

```bash
terraform destroy
```
