$Comp = "XLV1"
$Task = schtasks.exe /CREATE /TN "Reboot" /S $Comp /SC ONCE /ST 18:00 /RL HIGHEST /RU INTERACTIVE /TR "powershell.exe -ExecutionPolicy Unrestricted -WindowStyle Hidden -noprofile -File '\\xlin\Progress Bar Reboot.ps1'" /F
Start-Sleep -Seconds 5
$Run = schtasks.exe /RUN /TN "Reboot" /S $Comp