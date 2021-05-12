# Use Terraform to build an environment for testing SEC POC

Start from the `./azure` directory.

This creates a network of Linux and Windows Machines, you can RDP/SSH into the
respective Jumpboxes, and the jumpboxes themselves have Internet access. By default
the Linux/Windows 1 .. Linux/Windows N machines have no internet access, making the
environment similar to what we can expect inside the air-gapped facility.  We can
download files onto the jumpbox, transfer them to the Server machines for installation.
The Redhat 7.6 images being used in the "Private" portion were images that were created
by Brandon, to handle expanded disk sizes.

```plaintext
                                              No Internet - Private network
                                          +-------------------------------------+
+--------+         +---------+            |  +-----------+     +-------------+  |
|        |         |         |            |  |           |     |             |  |
|  You   |<-pubIp->| Jumpbox |<--privIp-->|  |  Linux 1  |     |  Windows 1  |  |
|        |         |  Linux  |            |  |           |     |             |  |
+--------+         +---------+            |  +-----------+     +-------------+  |
    ˄                                     |        ˄                   ˄        |
    |              +---------+            |        |                   |        |
    |              |         |            |        +-------------------+        |
    +----pubIP---->| Jumpbox |<--privIP-->|        |                   |        |
                   | Windows |            |        ˅                   ˅        |
                   +---------+            |  +-----------+     +-------------+  |
                                          |  |           |     |             |  |
                                          |  |  Linux N  |     |  Windows N  |  |
                                          |  |           |     |             |  |
                                          |  +-----------+     +-------------+  |
                                          +-------------------------------------+
```

## Provisioning the Environment with Terraform

### Edit terraform.tfvars

Set the environmentname and creator to something unique to spin up your own environment

```conf
client_secret = "" # your Azure Client Secret
resource_group = "myrg"
admin_user = "splice"
admin_pass = "P4$$w0rdNoP33k"
instance_size = "Standard_D4s_v3"
creator = "Splice Machine"
location = "East US"
windows_jumpboxes=[
    "w-jumpbox1"
]
windows_machines=[
    "w-server1"
]
linux_jumpboxes=[
    "l-jumpbox1"
]
linux_machines=[
    "l-server1"
    ,"l-server2"
    ,"l-server3"
    ,"l-server4"
]
subscription_id = ""
client_id       = ""
tenant_id       = ""
```

### Run Terraform

Ensure that you have authenticated with MFA before running Terraform or it will
appear to hang.

```bash
terraform init
terraform plan
terraform apply
# for some odd reason the TF fails every time on creating a public IP address
# and simply re-running "terraform apply" allows it to be created.  The error
# is complaining about the resource-group not being found, so likely a bug.
terraform apply
```

The `terraform apply` will output the public/private IP addresses and the VM names
as well as a command to get status of the VM instances.

#### Wait for instance to become "VM Running"

```bash
az vm get-instance-view --name <instance_name> --resource-group <resource-group> --output table
```

#### RDP to the Windows Jumpbox instance

Use "Microsoft Remote Desktop" from the App Store, or other RDP client to connect
to the instance using the public IP, Username and Password were set in the
`terraform.tfvars` file.

From the Jumpbox, you can run `mstsc` and then RDP using the Private IP address of the
other internal windows machine.

#### SSH to the Linux Jumpbox instance

```bash
# using the -A will allow you to then use ssh splice@<privateIP> to ssh to the internal machines
ssh -A -i winkey splice@<publicip>
```

##### Prep /dev/sdX

```bash
sudo fdisk -l
# check to see which of the devices is the correct DATA volume
# likely /dev/sdc or /dev/sda
# use "df -h" to determine if there are mounts against the /dev/sdX device
sudo parted /dev/sda mklabel gpt
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L data /dev/sda1
sudo mkdir /data
echo "LABEL=data /data ext4 defaults 0 2" | sudo tee -a /etc/fstab
sudo mount -a
df -h
```

#### Allow "internal" VMs access to the Internet

Simply go to the Azure Portal, navigate to the `Resource Group` and the
`Network Security Group` that has the suffix name of `-nsg-internal` and under
the `Outbound security rules` delete the `500 - DenyInternetOutbound` rule.  To
replace the rule, just run `terraform apply` again, and it will put the rule back.

#### Terraform Destroy

When you are completely done, run the following from the same directory
you ran the `terraform apply` from.

```bash
terraform destroy
```

## Installation of Small Footprint Splice

### Docker Image / Tags

| REPOSITORY                             | TAG    |
| -------------------------------------- | ------ |
| splicemachine/splicemachine-standalone | 0.0.10 |
| jpanko/ssds-standalone                 | 0.0.2  |
| splicemachine/splice-https             | 0.0.7  |
| splicemachine/sqlshell                 | latest |

### TODO

- [ ] THIS ENTIRE SECTION NEEDS TO BE UPDATED - since migration to Redhat / Windows mix
- [x] Need to get init command for ssds container and update the docker-compose.yaml for that
- [x] Need to push splicemachine/splicemachine-standalone:0.0.6 (after test) to splicesec.azurecr.io.
- [x] Need to push jpanko/ssds-standalone:0.0.2 (after test) to splicesec.azurecr.io/splicesec/ssds-standalone:0.0.2
- [x] Upload new command_list.txt to S3
- [x] Upload Download-NiFi-Resources.ps1 to S3
- [x] Upload Install-SpliceMachine-GrafanaPlugin.ps1 to S3
- [ ] Update Build-DockerCompose.ps1 with new TAGs and upload to S3
- [ ] It would be nice to have a streamlined START process for NiFi and Kafka (zookeeper/kafka)

### ISSUES / TESTING

#### SpliceDB Startup in Isolated Mode

Currently the db won’t start using docker-compose without internet access.  Had to run -it into the container, edit some scripts, and start manually.  The edits are:
Change line 75 of start-splice-cluster to MVN='mvn -B -o'
In lines 32 and 34 of sqlshell.sh, change mvn to mvn -o
And then run ./start-splice-cluster

### Docker Desktop Installation

- [ ] Machine 1
- [ ] Machine 2

```powershell
Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile Docker_Installer.exe
./Docker_Installer.exe
# accept all defaults during installation
# click Restart when prompted
# After restart, leave WSL2 dialog open and run the below in Powershell
```

```powershell
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi
./wsl_update_x64.msi
# click the restart button in the WSL2 dialog - This may not actually restart the computer, if Docker Desktop comes up
# without reboot, none is required. Wait for docker to come up - check the taskbar for the docker icon.
# Then run the command below in powershell to test if docker works as desired:
docker run --rm debian uname -a
# output should show a Linux based name
# Linux a4d9cf7eac7d 5.4.72-microsoft-standard-WSL2 #1 SMP Wed Oct 28 23:40:43 UTC 2020 x86_64 GNU/Linux
```

### Machine 1 - Splice Machine (docker based)

Download the docker-compose build script.

```powershell
cd $env:USERPROFILE
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/Build-DockerCompose.ps1 -OutFile Build-DockerCompose.ps1
./Build-DockerCompose.ps1
# this should create three directories: splicedb, splicehttp, and splicessds
# each directory should contain a docker-compose.yaml file.
```

#### Pull Required Docker Images

Pull the image from Docker

```powershell
docker login splicesec.azurecr.io
# Username: splicesec
# Password:
docker pull splicesec.azurecr.io/splicesec/splicemachine-standalone:0.0.10
docker pull splicesec.azurecr.io/splicesec/ssds-standalone:0.0.2
docker pull splicesec.azurecr.io/splicesec/splice-https:0.0.7
docker pull splicesec.azurecr.io/splicesec/sqlshell:latest

docker tag splicesec.azurecr.io/splicesec/splicemachine-standalone:0.0.10 splicemachine/splicemachine-standalone:0.0.10
docker tag splicesec.azurecr.io/splicesec/ssds-standalone:0.0.2 splicemachine/ssds-standalone:0.0.2
docker tag splicesec.azurecr.io/splicesec/splice-https:0.0.7 splicemachine/splice-https:0.0.7
docker tag splicesec.azurecr.io/splicesec/sqlshell:latest splicemachine/sqlshell:latest
```

#### Start the Splice Machine Database

```powershell
cd $env:USERPROFILE\splicedb
docker-compose.exe up -d
```

**Database start may take a few minutes.**

As the Windows firewall dialog pops up, allow docker access to all networks and click OK

- run SQLShell

```powershell
# we need the IP address because running using localhost the docker container tries
# to connect to itself.  We need it to reach out to the host machine and connect on
# 1527, which would be the running splicedb container
$defaultNetInterface = (Get-NetRoute |Where-Object {$_.DestinationPrefix -eq "0.0.0.0/0" } |Select-Object -Property ifIndex).ifIndex
$ipAddress = (Get-NetIPAddress -AddressFamily IPV4 | Where-Object {$_.InterfaceIndex -eq $defaultNetInterface}).IPAddress
docker run --rm -it splicemachine/sqlshell -U "jdbc:splice://$($ipAddress):1527/splicedb;user=splice;password=admin"
```

- then run this DDL in sqlshell:

```sql
DROP TABLE IF EXISTS "SPLICE"."CH1DEVICE1";
CREATE TABLE "SPLICE"."CH1DEVICE1" (
"ITEM" VARCHAR(100) NOT NULL
,"SERVERTIME" TIMESTAMP
,"SOURCETIME" TIMESTAMP NOT NULL
,"VALUE" DOUBLE
,"STATUS" BIGINT
,"NAMESPACE" VARCHAR(50)
,"CHANNEL" VARCHAR(50)
,"TAG" VARCHAR(100)
,"UNIT" VARCHAR(100)
,"STAG" VARCHAR(100)
, PRIMARY KEY("ITEM","SOURCETIME")) ;
```

#### Splice SSDS Service

The table above `CH1DEVICE1` must be created prior to running this next service.

```powershell
cd $env:USERPROFILE\splicessds
docker-compose.exe up -d
```

#### SpliceHttps Service

```powershell
cd $env:USERPROFILE\splicehttp
docker-compose.exe up -d
```

### Machine 2 - NiFi Native Windows / Kafka under Docker

#### Nifi on Windows

```powershell
cd $env:USERPROFILE
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/Download-NiFi-Resources.ps1 -OutFile Download-NiFi-Resources.ps1
.\Download-NiFi-Resources.ps1
./jre-8u281-windows-x64.exe
# accept defaults during run
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jre1.8.0_281", "Machine")
$env:JAVA_HOME="C:\Program Files\Java\jre1.8.0_281"
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/nifi-opcua.nar -OutFile .\nifi\nifi-1.13.2\lib\nifi-opcua.nar
cd nifi\nifi-1.13.2\bin
.\run-nifi.bat

# note, in conf/nifi.properties file, set "nifi.web.http.host=0.0.0.0" to access remotely, otherwise http://localhost:8080/nifi only from the NiFi machine.

# for troubleshooting
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/prosys-opc-ua-client-3.2.0-328.exe -OutFile prosys-opc.exe
./prosys-opc.exe
# Accept defaults during install
# Test OPC UA connection by trying to connect to opc.tcp://OPCSERVERIP:49320
```

#### Kafka Under Docker

```powershell
cd $env:USERPROFILE
if ( -Not ( Test-Path -Path kafka ) ) {
   New-Item -ItemType Directory -Name kafka
}
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/kafka-bin.zip -OutFile kafka.zip
Expand-Archive .\kafka.zip -DestinationPath .\
# to start kafka's zookeeper, and kafka
# open a powershell window (a new one)
cd $env:USERPROFILE\kafka
.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
# you might be prompted to allow network traffic on Private Networks, select to do so
# open another new powershell window
cd $env:USERPROFILE\kafka
.\bin\windows\kafka-server-start.bat .\config\server.properties
```

### Machine 3 - OPC and Grafana

#### Grafana / Kepware

##### Grafana Standalone

```powershell
cd $env:USERPROFILE
Invoke-WebRequest -Uri https://dl.grafana.com/oss/release/grafana-7.5.3.windows-amd64.msi -OutFile grafana-7.5.3.windows-amd64.msi
./grafana-7.5.3.windows-amd64.msi
# Accept all defaults in the GRafana installation wizard
# once installed, http://localhost:3000/
# logon: admin/admin, change password
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/Install-SpliceMachine-GrafanaPlugin.ps1 -OutFile Install-SpliceMachine-GrafanaPlugin.ps1
.\Install-SpliceMachine-GrafanaPlugin.ps1
# the above should list splicemachine as an installed plugin
```

- [ ] Requirement: splicehttp docker-compose needs to be running on Machine 1

Navigate to http://localhost:3000/

Once restarted and the plugin is verified, we open Grafana again and choose the Gear from the left menu, and Data Sources.  We search
for and add a Splice Machine Data Source, with the following settings:

```yaml
Name: Splice Machine                           # no chnage
URL: http://<ip address of machine1>:8443/
User: <splicedb username>                      # default "splice"
Password: <splicedb password>                  # default "admin"
```

Click the "Test and Save" button, and if successful, click the "Back" button, and you are ready to go.

You can also import the test dashboard by clicking on the four little squares in the left hand menu and select “manage”. Then click the “import” button and “upload JSON file” in the next screen. Navigate to the file “TestData...json”, keep the defaults and click “import”. Now you can run the dashboard and it should show live data if everything works fine.

```powershell
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/Real+Data-1618431004082.json -OutFile .\Downloads\Real+Data-1618431004082.json
```

##### Kepware Standalone

```powershell
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/kepware_install.exe -OutFile kepware_install.exe
./kepware_install.exe

# keep all options as default, select “typical” installation type, select “Examples and
# Documentation” to be installed locally (for testing). You can skip setting an Admin password

# When the installer finishes, there should be a small green Kep logo showing in the taskbar.
# Right click and select “OPC UA configuration”. Click “Add…” and add the right network
# interface (or just do all), select “None” for security and deselect any other. Make sure all URLs
# are enabled and close.
# NOTE: It is possible the interface is already there and just needs to be edited to deselect the security.
#
# Launch KepServerEX configuration through the shortcut on the desktop. In Kep, right click
# “Project” in the navigation tree on the left and select “properties”. Select “OPC UA” and set
# “Allow anonymous login” to “yes”.
# To test if Kep works, if the samples have been installed you can run the Quick Client by
# clicking the small “QC” icon in the Kep menu bar and select “Channel1.Device1” where you
# should see the first tag count up values once every second. Close the Quick Client without
# saving and you’re done.
#
# If available, go to Kepware license manager and install and activate your license. We may
# have to do that using the offline process once the systems are on site since a change in
# IP / network may render the license invalid.
```

### Common Tools / Setup on each Windows Machine

#### Command Line List

```powershell
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/command_list.txt  -OutFile command_list.txt
notepad command_list.txt
```

#### Disabling the Windows Firewall

```powershell
# disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
# install Windows Telnet-Client
dism /online /Enable-Feature /FeatureName:TelnetClient
```

#### Running SQL Shell via Docker Container

```powershell
# we need the IP address because running using localhost the docker container tries
# to connect to itself.  We need it to reach out to the host machine and connect on
# 1527, which would be the running splicedb container
$defaultNetInterface = (Get-NetRoute |Where-Object {$_.DestinationPrefix -eq "0.0.0.0/0" } |Select-Object -Property ifIndex).ifIndex
$ipAddress = (Get-NetIPAddress -AddressFamily IPV4 | Where-Object {$_.InterfaceIndex -eq $defaultNetInterface}).IPAddress
docker run --rm -it splicemachine/sqlshell -U "jdbc:splice://$($ipAddress):1527/splicedb;user=splice;password=admin"
```

Helpful tool: Prosys OPC UA client to test OPC connectivity (currently on GDrive only, download would be via signup page, so recommend to move it to S3 as well.
