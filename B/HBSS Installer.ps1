﻿
# -------

$Computers = Get-Content "\\XS.txt"

$Path = "\\XLWBSS.csv"

$MaxThreads = 60

# SCRIPT BEGINS
# -------------

$Start = Get-Date

$i = $null
$TotalJobs = $Computers.Count
$Counter = $null

$ScriptBlock = {
    If (Test-Connection $args[0] -Quiet -Count 1 -BufferSize 16 -Ea 0)
    {
        $Ping = "Online"
        Try
        {
            $Task = schtasks.exe /CREATE /TN "HBSS" /S $args[0] /SC ONLOGON /RU "INTERACTIVE" /TR "powershell.exe -noprofile -File '\\tall.ps1'" /F  
            $Run = schtasks.exe /RUN /TN "HBSS" /S $args[0] 
            Sleep -Seconds 3 
            $Delete = schtasks.exe /DELETE /TN "HBSS" /S  $args[0] /F
            $Status = "Task Scheduled"
        }
        Catch {$Status = "Task Failed"}
    }
    Else
    {
        $Ping = "Offline"
    }

    $Results = [PSCustomObject]@{
        System = $args[0]
        Ping = $Ping
        Status = $Status
        }
    
    $Results
}

ForEach ($Computer in $Computers)
{
    Write-Host "Starting Job on: $Computer" -ForegroundColor Cyan
    $i++
    Write-Host "Status: $i / $TotalJobs" -ForegroundColor Yellow

    Start-Job -Name $Computer -ScriptBlock $ScriptBlock -ArgumentList $Computer | Out-Null

    While ($(Get-Job -State Running).Count -ge $MaxThreads)
    {
        Get-Job | Wait-Job -Any | Out-Null
    }
}

While ($(Get-Job -State Running).Count -ne 0)
{
    $JobCount = (Get-Job -State Running).Count
    Start-Sleep -Seconds 1
    $Counter++
    Write-Host "Waiting for $JobCount Jobs to complete: $Counter" -ForegroundColor DarkYellow

    If ($Counter -gt 80)
    {
        Write-Host "Exiting loop $JobCount Jobs did not complete"
        Get-Job -State Running | Select Name
        Break
    }
}

$Outcome = Get-Job | Receive-Job
$Outcome | Select System, Ping, Status -ExcludeProperty RunspaceId | Export-Csv $Path -Force
Import-Csv $Path | OGV -Title "Java Push"

$Stop = Get-Date
$TimeS = ($Stop - $Start).Seconds
$TimeM = [Math]::Round(($Stop - $Start).TotalMinutes, 0)
Write-Host
Write-Host "Elapsed Time: $TimeM min $TimeS sec" -ForegroundColor Cyan

Get-Job | Remove-Job -Force