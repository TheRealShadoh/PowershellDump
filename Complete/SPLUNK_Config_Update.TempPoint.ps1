# Path of configuration file
$ConfPath = 'C:\Users\Administrator\Desktop\Scripts\Development\CONF TEST.txt'

# Gather contents of configuration File
$ConfContent = Get-Content -Path $ConfPath

# Insert changes at indexed path
$ConfContent[0] = "hostname = $($env:Computername)"

$ConfUpdate = $ConfContent | Out-File $ConfPath -Force


