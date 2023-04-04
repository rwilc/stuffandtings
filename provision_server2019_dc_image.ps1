## Download GPO CMD Line Tool

Invoke-WebRequest -Uri "https://github.com/rwilc/stuffandtings/raw/main/Tools/LGPO/LGPO_30/LGPO.exe" -OutFile "c:\Staging\LGPO.exe"

## Download benchmarks from Git

Invoke-WebRequest -Uri "https://github.com/rwilc/stuffandtings/raw/main/CIS_Server2019v1.3.0.zip" -OutFile "c:\Staging\CIS_Server2019v1.3.0.zip"

## Unzip Benchmarks

$benchmarkzip = "c:\Staging\CIS_Server2019v1.3.0.zip"

Expand-Archive -Path $benchmarkzip -DestinationPath "C:\Staging\"

## Remove Benchmark zip file now unpackaed

Remove-Item -Path "c:\Staging\CIS_Server2019v1.3.0.zip"
