cls
<#  .DESCRIPTION

Multi-thread tool

Creates/Sets a custom Environmental variable containing the current patch level of VSE

Object details for the final variable of $outcome

Target_ID - Variable input from list
Ping - if ONLINE or OFFLINE
Task_Status - Did the task schedule
Error - Recorded Error Message
Success - True or False value to track and record numbers from push
Version - The current version of VSE after the script runs

Use $outcome to view results
#>


#Timer
$sw = new-object system.diagnostics.stopwatch
$sw.Start()

# Target List
# Change the value between "    "   to match your computer list
$Comps = "localhost"


$scriptblock = {
    $ErrorActionPreference = 'Stop'
    #TRY to accomplish tasks
    TRY {
            #Check if machine ONLINE if OFFLINE do nothing    
            IF (Test-Connection $args -Quiet -Count 1 -buffersize 16) {
                #ONLINE
                $ping = "Online"
                #
                # EDIT BELOW THIS LINE
                #
                $Value = "3.0.1" #Sets the variable to this value
                $current = [Environment]::GetEnvironmentVariable("Version", "Machine")
                IF ($current -ne $Value) {
                    [Environment]::SetEnvironmentVariable("Version", "$Value", "Machine")
                    } 
                ELSE {
                    exit
                }
                
                #
                # EDIT ABOVE THIS LINE
                #
                $success = "True"
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
                     Task_Status = $run
                     Error = $stop
                     Success = $success
                     Version = $current
                     } 
    #Print to console
    $RemoteObj

    }

# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE
# DO NOT EDIT BELOW THIS LINE

###########################
# JOB CREATION AND CONFIG #
###########################
$i = 0 #Counter
$totalJobs = $comps.Count #Used for calculating counter
$MaxThreads = 60 #Max amount of threads you can raise or lower this depending how strong your system is. 60 seems to be a sweet spot for normal desktops.
$counter = 0

 Foreach ($comp in $comps) {
        Write-Host "Starting Job on: $comp" -ForegroundColor Cyan -BackgroundColor DarkGray
        $i++
        Write-Host "________________Status :$i / $totalJobs" -ForegroundColor Yellow -BackgroundColor DarkGray

        Start-Job -name $comp -ScriptBlock $scriptblock -argumentlist $comp |Out-Null
        
        While($(Get-Job -State Running).Count -ge $MaxThreads) {Get-Job | Wait-Job -Any |Out-Null}
} #End ForEach
$ErrorActionPreference = 'SilentlyContinue'

While ($(Get-Job -state running).count -ne 0){
$jobcount = (Get-Job -state running).count
Write-Host "Waiting for $jobcount Jobs to Complete: $counter" -foregroundcolor DarkYellow
Start-Sleep -seconds 1
$Counter++

    if ($Counter -gt 40) {
                Write-Host "Exiting loop $jobCount Jobs did not complete"
                get-job  -state Running | select Name
                break
            }

}

$outcome = Get-job | Receive-Job #Pull data into $outcome                      
           Get-Job | Remove-Job -force #Delete all jobs
$sw.stop()


# Information is stored in the $outcome variable additionally it is saved to your C: 
Write-Warning "Data can be viewed and manipulated with object named: OUTCOME"
$nl
Write-Host "Statistics" -ForegroundColor Cyan
Write-Host "Total Systems: $(($comps).count)" -ForegroundColor Gray
Write-Host "Systems Online: $(($outcome.ping |where {$_ -eq "ONLINE"}).count)" -foregroundcolor Green
Write-Host "Systems Offline: $(($outcome.ping |where {$_ -eq "OFFLINE"}).count)" -foregroundcolor DarkYellow
Write-Host "Fix Attempted on: $(($outcome.ping |where {$_ -eq "ONLINE"}).count)" -foregroundcolor Gray
Write-Host "Fix CLEARED on:$(($outcome | where{$_.success -eq "True"} ).count)" -foregroundcolor Green
Write-host "Fix ERRORED on: $(($outcome | where{$_.success -eq "False"}).count)" -foregroundcolor Red
Write-host "Success Rate: $($($($(($outcome | where{$_.success -eq "True"}).count) / ($outcome.ping | where {$_ -eq "ONLINE"}).count)) * 100) %" -ForegroundColor Yellow -BackgroundColor DarkGray
$nl
$nl
Write-host "Elapsed Time: $($sw.Elapsed.Minutes) Minutes" -ForegroundColor Cyan -BackgroundColor DarkGray
$nl
Write-Host "To manipulate results within PoSH use the OUTCOME variable -- Otherwise check your C: drive for the output file" -ForegroundColor Cyan

$Date = Get-Date -UFormat "%d-%b-%g %H%M"
$outcome | Export-Csv -append "C:\Patcher_$date.csv"
                       

