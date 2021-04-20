Invoke-WebRequest -Uri https://github.com/splicemachine/grafana/archive/dev009.zip -OutFile dev009.zip
Expand-Archive -LiteralPath .\dev009.zip -DestinationPath 'C:\Program Files\GrafanaLabs\grafana\data\plugins\'
Move-Item -Path 'C:\Program Files\GrafanaLabs\grafana\data\plugins\grafana-dev009\grafana-plugins\splice-plugin' -Destination 'C:\Program Files\GrafanaLabs\grafana\data\plugins\'
Remove-Item -Path 'C:\Program Files\GrafanaLabs\grafana\data\plugins\grafana-dev009' -Force -Recurse
Restart-Service Grafana
cd 'C:\Program Files\GrafanaLabs\grafana\bin'
./grafana-cli plugins ls
cd $env:USERPROFILE
