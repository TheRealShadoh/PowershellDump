﻿$Comp = "XXV"
$Task = schtasks.exe /CREATE /TN "Notify" /S $Comp /SC ONLOGON /RL HIGHEST /RU SYSTEM /TR "powershell.exe -ExecutionPolicy Bypass -File '\\xlation.ps1'" /F  
$Run = schtasks.exe /RUN /TN "Notify" /S $Comp 
Sleep -Seconds 5 
#$Delete = schtasks.exe /DELETE /TN "Fix" /s  $Comp /F