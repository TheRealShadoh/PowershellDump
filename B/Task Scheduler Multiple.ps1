﻿$Comps = Get-Content C:\Users\\Desktop\Comps.txt
ForEach ($Comp in $Comps)
{
    If (Test-Connection $Comp -Quiet -BufferSize 16 -Ea 0 -Count 1)
    {
        $Task = schtasks.exe /CREATE /TN "Delete Old Profiles" /S $Comp /SC WEEKLY /D SAT /ST 23:59 /RL HIGHEST /RU SYSTEM /TR "powershell.exe -ExecutionPolicy Unrestricted -WindowStyle Hidden -noprofile -File '\\xl-in\Delete Old Profiles.ps1'" /F
        $Run = schtasks.exe /RUN /TN "Delete Old Profiles" /S $Comp
    }
    Else
    {
        Write-Host "$Comp offline"
    }
}