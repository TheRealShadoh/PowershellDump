cls
<#  .DESCRIPTION
Multi-threaded
Run from DC
Utilize an account with access to all computers registries
    .MISSING_FUNCTIONALITY
    
    .CHANGELOG
#>


$nl = [Environment]::newline
$creds = Get-Credential
# Timer
$sw = New-Object System.Diagnostics.Stopwatch
$sw.Reset()
$sw.Start()

# Target list
$Comps = Get-ADComputer -filter *

# Program Key
$Program = "*"

$Scriptblock = {
    $ErrorActionPreference = 'Stop'

    # Try to accomplish tasks
    TRY {
        # Check if machine is ONLINE, if OFFLINE do nothing
        IF (Test-Connection $args[0] -Quiet -Count 1 -BufferSize 16) {
            # ONLINE
            $ping = "Online"
            $success= "True"
            # 64 Bit Registry scan
            $RegPath = "Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
            $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$args[0])
            $RegKey = $Reg.OpenSubKey($RegPath)
            $SubKeys = $RegKey.GetSubKeyNames()
            $array = @()
            Foreach ($Key in $SubKeys){
                $ThisKey = $RegPath+"\\"+$Key
                $ThisSubKey = $Reg.OpenSubKey($ThisKey)
                $Program_Name = $ThisSubKey.GetValue("DisplayName")
                $Display_Version = $ThisSubKey.GetValue("DisplayVersion")
                $Publisher = $ThisSubKey.GetValue("Publisher")
                $CombinedValue = "$($args[0])" + "//" +"$($Publisher)" + "//" +"$($($Program_Name | Where {$_.length -ne 0}))" + "//" +"$($Display_Version)"
                $CombinedValue = $CombinedValue | Select -Unique
                $array += $CombinedValue | Where {$_ -ne "////////" -and $_.length -ne 0}
                }

            # 32 Bit Registry scan
            $RegPath = "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
            $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$args[0])
            $RegKey = $Reg.OpenSubKey($RegPath)
            $SubKeys = $RegKey.GetSubKeyNames()
            $array = @()
            Foreach ($Key in $SubKeys){
                $ThisKey = $RegPath+"\\"+$Key
                $ThisSubKey = $Reg.OpenSubKey($ThisKey)
                $Program_Name = $ThisSubKey.GetValue("DisplayName")
                $Display_Version = $ThisSubKey.GetValue("DisplayVersion")
                $Publisher = $ThisSubKey.GetValue("Publisher")
                $CombinedValue = "$($args[0])" + "//" +"$($Publisher)" + "//" +"$($($Program_Name | Where {$_.length -ne 0}))" + "//" +"$($Display_Version)"
                $CombinedValue = $CombinedValue | Select -Unique
                $array += $CombinedValue | Where {$_ -ne "////////" -and $_.length -ne 0}
                }

            # Combine 32 and 64 bit, remove duplcates, split the string, add to custom object, insert into final array for printing
            $masterarray = @()
            $array = $array | Select -Unique
            Foreach ($obj in $array){
                $RemoteObj = New-Object PSCustomObject
                $RemoteObj | Add-Member -MemberType NoteProperty -Name "Computer" -Value ($obj -split "//")[0]
                $RemoteObj | Add-Member -MemberType NoteProperty -Name "Vendor" -Value ($obj -split "//")[1]
                $RemoteObj | Add-Member -MemberType NoteProperty -Name "Program" -Value ($obj -split "//")[2]
                $RemoteObj | Add-Member -MemberType NoteProperty -Name "Version" -Value ($obj -split "//")[3]
                $Masterarray += $RemoteObj
                }
        } # End IF
        ELSE {
            $ping = "Offline"
            }
    } # End TRY
    Catch {
        $stop = $error.exception.message
        $success = "False"
        }
    # Print to Console
    $MasterArray
    
}

##################################
# JOB CREATION AND CONFIGURATION #
##################################

## CONFIG
# Counter
$i = 0 
$TotalJobs = $comps.count
$MaxThreads = 74
$timeout = "300"
$Counter = "0"

## Creation
Foreach ($comp in $comps.name) {
    ## BEGINNING
    Write-Host "Starting Job on: $comp" -ForegroundColor Cyan -BackgroundColor DarkGray
    $i++
    Write-host "_______________Status : $i / $TotalJobs" -ForegroundColor Yellow -BackgroundColor DarkGray
    Start-Job -name $Comp -Credential $creds -ScriptBlock $Scriptblock -ArgumentList $comp,$program | Out-Null
## During
# If jobs are still running, exceed the max threads, script will wait to open new jobs.
    While ($(Get-Job -State Running).Count -ge $MaxThreads) {
        Get-Job | Wait-Job -Any
        }
    } # End FOREACH

## END
# Wait until no more jobs are running
While ($(Get-Job -State Running).Count -ne 0){
    $JobCount = (Get-Job -state running).count
    Write-Host "Waiting for $jobcount Jobs to complete: $counter" -ForegroundColor DarkYellow 
    Start-Sleep -Seconds 1
    $counter++

    # Break if exceed timeout
    IF ($counter -gt $timeout){
        Write-Host "Exiting Loops $JobCount Jobs did not complete"
        Get-Job -State Running | Select Name
        break
        }
    } # End While


##################################
#              END               #
##################################

Write-Host "Jobs Complete" -ForegroundColor Red -BackgroundColor Yellow

Write-Host "Gathering jobs" -ForegroundColor Red -BackgroundColor Yellow
$outcome = Get-Job | Receive-Job

Write-Host "Removing old jobs" -ForegroundColor Red -BackgroundColor Yellow
Get-job | Remove-Job -Force

Write-Host "Formatting up data" -ForegroundColor Red -BackgroundColor Yellow
$FinalArray = @()
Foreach ($obj in $outcome | where {$_.program.length -ne 0}){
    $RemoteObj = New-Object PSCustomObject
    $RemoteObj | Add-Member -MemberType NoteProperty -Name "Computer" -Value $obj.computer
    $RemoteObj | Add-Member -MemberType NoteProperty -Name "Vendor" -Value $obj.vendor
    $RemoteObj | Add-Member -MemberType NoteProperty -Name "Program" -Value $obj.program
    $RemoteObj | Add-Member -MemberType NoteProperty -Name "Version" -Value $obj.version
    $finalArray += $RemoteObj
    }

$outcome = $FinalArray
$sw.stop()

$outcome = $outcome | Select-Object -Property * -ExcludeProperty RunspaceID
$outcome | Export-Csv C:\temp\SVDOutcome.csv -Force -NoTypeInformation

Write-Warning "Data can be viewed and manipulated with the OUTCOMe variable, if script is run within ISE"
$nl
Write-Host "Elapsed time: $($sw.Elapsed.Minutes)" -ForegroundColor Cyan -BackgroundColor DarkGray
$nl
Write-Warning "Output is located at C:\Temp\SVDOutcome.csv"
Invoke-Item "C:\Temp\SVDOutcome.csv"
Read-Host "Press Enter to close this window"

