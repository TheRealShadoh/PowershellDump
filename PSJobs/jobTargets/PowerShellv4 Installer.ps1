$ErrorActionPreference = 'SilentlyContinue'
Get-Process | Where { $_.ProcessName -like "*Powershell*" } | ForEach-Object { Stop-Process $_.ProcessName -Force }
Write-Host "Installing Flash Player Plugin"
Start-Process "\\ [path] \PowerShellv4_Install.msu" /qn -wait

Msg console "PowerShell Updated"