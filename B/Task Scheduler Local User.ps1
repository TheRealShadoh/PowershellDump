$Comp = "XLWYC"
$Task = schtasks.exe /CREATE /TN "Java" /S $Comp /SC WEEKLY /D SAT /ST 23:59 /RU INTERACTIVE /TR "PowerShell.exe -ExecutionPolicy Unrestricted -WindowStyle Hidden -noprofile -file '\\xldmin\Java_Install.ps1'" /F
$Run = schtasks.exe /RUN /TN "Java" /S $Comp
Sleep -Seconds 5
$Delete = schtasks.exe /DELETE /TN "Java" /S  $Comp /F