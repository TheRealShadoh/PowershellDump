cls

# Object details for the final variable of $outcome
#
# Target_ID - Variable input from list
# Ping - if ONLINE or OFFLINE
# Task_Status - Did the task schedule
# Error - Recorded Error Message
# Success - True or False value to track and record numbers from push
#
# 

$nl = [Environment]::newline

#Timer
$sw = new-object system.diagnostics.stopwatch
$sw.reset()
$sw.Start()

#Target List
$Comps = Get-ADComputer -Filter * 
$comps = $comps.name

#Script to be pushed to machines
#Setup in a cookie cutter to call an external script that does the job. 


$scriptblock = {
    $ErrorActionPreference = 'Stop'
    #TRY to accomplish tasks
    TRY {
            #Check if machine ONLINE if OFFLINE do nothing    
            IF (Test-Connection $args[0] -Quiet -Count 1 -buffersize 16) {
                #ONLINE
                $ping = "Online"
                $success = "True"
                $RegPath = "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall"        
                $Reg = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$args[0])
                $RegKey = $Reg.OpenSubKey($RegPath)
                $SubKeys = $RegKey.GetSubKeyNames()
                $Array = @()
                    ForEach($Key in ($SubKeys)){
                    $ThisKey = $RegPath+"\\"+$Key 
                    $ThisSubKey = $Reg.OpenSubKey($ThisKey)
                    $Program_Name = $thisSubKey.GetValue("DisplayName")
                    $Program_Version = $ThisSubKey.GetValue("DisplayVersion")
                        $InternalObj = [PSCustomObject]@{
                            Computer = $args[0]
                            Program = $Program_Name
                            Version = $Program_Version
                        }
                    $InternalObj = $InternalObj | where {$_.Program.Length -gt "0"}
                    $Array += $InternalObj
                    }                                 
              } # END IF
            ELSE {
                $ping = "Offline" 
            } # END ELSE
    } #END Try
    Catch {
                $stop = $error.exception.message
                $success = "False"
                
    } # END CATCH

    #Information to be passed to the console and collected
    $RemoteObj = [PSCustomObject]@{
                     Target_ID = $args[0]
                     Ping = $ping
                     Error = $stop
                     Success = $success
                     Data = $Array
                     } 
    #Print to console
    $RemoteObj

    }


###########################
# JOB CREATION AND CONFIG #
###########################
$i = 0 #Counter
$totalJobs = $comps.Count #Used for calculating counter
$MaxThreads = 20 #Max amount of threads
$jobs = @()

 Foreach ($comp in $comps) {
        Write-Host "Starting Job on: $comp" -ForegroundColor Cyan -BackgroundColor DarkGray
        $i++
        Write-Host "________________Status :$i / $totalJobs" -ForegroundColor Yellow -BackgroundColor DarkGray

        Start-Job -name $comp -ScriptBlock $scriptblock -argumentlist $comp,$program |Out-Null
        
        While($(Get-Job -State Running).Count -ge $MaxThreads) {Get-Job | Wait-Job -Any |Out-Null}
} #End ForEach

#$jobs | Add-Member -MemberType NoteProperty -Name Started -Value $null

While ($(Get-Job -state running).count -ne 0){Get-Job -State Running| Wait-Job -timeout 5|Stop-Job
    Write-Host "Remaining Systems : $((Get-job -State Running).count)" -ForegroundColor DarkYellow
}


$outcome = Get-job | Receive-Job #Pull data into $outcome                      
           Get-Job | Remove-Job -force #Delete all jobs
$sw.stop()

#$outcome | Select-Object -Property * -ExcludeProperty RunspaceID |ogv #Print Job 

$objSuccess = ($outcome.Success |where {$_ -eq "True"}).count
$objTotalAttempts = ($outcome.ping |where {$_ -eq "ONLINE"}).count
$num = $objSuccess / $objTotalAttempts
$percent = "{0:N2}%" -f ($num * 100)

#cls



Write-Warning "Data can be viewed and manipulated with object named: OUTCOME"
Write-Warning "Program Data is in OUTCOME.DATA"
$nl
Write-Host "Statistics" -ForegroundColor Cyan
Write-Host "Total Systems: $(($comps).count)" -ForegroundColor Gray
Write-Host "Systems Online: $(($outcome.ping |where {$_ -eq "ONLINE"}).count)" -foregroundcolor Green
Write-Host "Systems Offline: $(($outcome.ping |where {$_ -eq "OFFLINE"}).count)" -foregroundcolor DarkYellow
Write-Host "Fix Attempted on: $(($outcome.ping |where {$_ -eq "ONLINE"}).count)" -foregroundcolor Gray
Write-Host "Fix CLEARED on: $(($outcome.Success |where {$_ -eq "True"}).count)" -foregroundcolor Green
Write-host "Fix ERRORED on: $(($outcome.Success |where {$_ -eq "False"}).count)" -foregroundcolor Red
Write-host "Success Rate: $percent" -ForegroundColor Yellow -BackgroundColor DarkGray
$nl
$nl
Write-host "Elapsed Time: $($sw.Elapsed.Minutes)" -ForegroundColor Cyan -BackgroundColor DarkGray                        
