Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/nifi-1.13.2-bin.zip -OutFile nifi-1.13.2-bin.zip
if ( -Not ( Test-Path -Path nifi ) ) {
   New-Item -ItemType Directory -Name nifi
}
Expand-Archive -LiteralPath nifi-1.13.2-bin.zip -DestinationPath './nifi/'
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/jre-8u281-windows-x64.exe -OutFile jre-8u281-windows-x64.exe
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/SEC_NIFI.xml -OutFile .\Downloads\SEC_NIFI.xml
Invoke-WebRequest -Uri https://dominik-splice.s3.eu-central-1.amazonaws.com/on-prem/resources/tags.csv -OutFile .\Downloads\tags.csv
