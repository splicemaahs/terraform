$defaultNetInterface = (Get-NetRoute |Where-Object {$_.DestinationPrefix -eq "0.0.0.0/0" } |Select-Object -Property ifIndex).ifIndex
$ipAddress = (Get-NetIPAddress -AddressFamily IPV4 | Where-Object {$_.InterfaceIndex -eq $defaultNetInterface}).IPAddress

if ( -Not ( Test-Path -Path splicedb ) ) {
    New-Item -ItemType Directory -Name splicedb
}
if ( -Not (Test-Path -Path splicehttp ) ) {
    New-Item -ItemType Directory -Name splicehttp
}
if ( -Not (Test-Path -Path splicessds ) ) {
    New-Item -ItemType Directory -Name splicessds
}


$splicedb = @"
version: "3"

services:
  splice:
    image: 'splicemachine/splicemachine-standalone:0.0.10'
    command: ./start-splice-cluster
    environment:
      HOST_IP: '$($ipAddress)'
    ports:
      - "1527:1527"
      - "9092:9092"
      - "19092:19092"
      - "8080:8080"
      - "4040:4040"
      - "4041:4041"
      - "8090:8090"
      - "8091:8091"
"@

$splicehttp = @"
version: "3"

services:
  splicehttp:
    image: 'splicemachine/splice-https:0.0.7'
    environment:
      RELEASE_NAME: 'splice-test'
      FRAMEWORKID: 'splice-test'
      TZ: 'UTC'
      SERVICE_NAME: '$($ipAddress)'
      DOMAIN_NAME: '$($ipAddress)'
      DB_HOST: '$($ipAddress)'
      HDFS_HOST: '$($ipAddress)'
    ports:
      - "8443:1111"
"@

$splicessds = @"
version: "3"

services:
  splicessds:
    image: 'splicemachine/ssds-standalone:0.0.2'
    command: |
      /bin/bash -c
      './bin/spark-submit \
      --class KafkaReader \
      --master local[*] \
      --conf `"spark.sql.catalogImplementation=in-memory`" \
      --conf `"spark.driver.extraClassPath=../*`" \
      --conf `"spark.executor.extraClassPath=../*`" \
      --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.1 \
      --driver-class-path `"../splice-machine-spark-connector-assembly-3.1.0.2002.jar`" \
      ../splice-machine-spark-connector-assembly-3.1.0.2002.jar KafkaToSplice \
      `"$($ipAddress):19092`" \
      kepware_opc \
      `"ITEM STRING, SERVERTIME STRING, SOURCETIME STRING, VALUE FLOAT, STATUS LONG, NAMESPACE STRING, CHANNEL STRING, TAG STRING, UNIT STRING, STAG STRING`" \
      `"jdbc:splice://$($ipAddress):1527/splicedb;user=splice;password=admin`" \
      Ch1Device1 \
      `"$($ipAddress):19092`" \
      1 \
      1 \
      2 \
      false'
"@


Write-Verbose $splicedb -Verbose
Write-Verbose $splicehttp -Verbose
Write-Verbose $splicessds -Verbose

Write-Output $splicedb | Out-File -FilePath ./splicedb/docker-compose.yaml
Write-Output $splicehttp | Out-File -FilePath ./splicehttp/docker-compose.yaml
Write-Output $splicessds | Out-File -FilePath ./splicessds/docker-compose.yaml
