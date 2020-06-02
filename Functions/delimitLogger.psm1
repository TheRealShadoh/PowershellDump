function Start-DelimitLogger {
    <#
    Create global variable to record logging status to an array or to a file, store file path and array here.
    Allows new-delimit logger to not care about being told the log file path or array to store the logs in
    #>
    param(
        [ValidateSet('TRUE', 'FALSE')]
        $ToFile,
        $LogFilePath
    )

    if ($ToFile) {
        New-Item -Path $LogFilePath -Force
        $global:runningDelimitLogger = @{"running" = $true; "toFile" = $true; "toFileLogPath" = $LogFilePath; "toArray" = $false }
        return $true
    }

    $global:runningDelimitLogger = @{"running" = $true; "toFile" = $false; "toFileLogPath" = $false; "toArray" = $true; "logArray" = @() }

}

function Stop-DelimitLogger {
    <#
    Based on log type, print the array or tell the file path.
    Set running to false
    #>

    param()
    if ($global:runningDelimitLogger.toArray) {
        $global:runningDelimitLogger.running = $false
        return Write-Output "Log closed, should have used get-delimitlogger to pull the data"
    }
    $global:runningDelimitLogger = $false
    return Write-Output "Log file complete, check: $($global:runningDelimitLogger.toFileLogPath)"
}


function New-DelimitLogger {
    <#
    Create new log entry
    Checks global variable from start-delimitlogger for if to file or array
    Accepts up to 5 custom columns
    Allows quiet running, or printing to console
    Delimiter set to :: by default but can be changed with -Delimiter
    #>
    param(
        [string]$Delimiter = " ~ ",
        [Parameter(Mandatory)]
        [ValidateSet('ERROR', 'INFO', 'SUCCESS', 'WARNING')]
        [string]$Category,
        $Message,
        [string]$CustomColumn1,
        [string]$CustomColumn2,
        [string]$CustomColumn3,
        [string]$CustomColumn4,
        [string]$CustomColumn5,
        [ValidateSet('TRUE', 'FALSE')]
        $isVerbose
    )

    if (-not ($global:runningDelimitLogger.running)) {
        return Write-Warning "Must run Start-DelimitLogger first!"
    }


    #get timestamp / force message string
    $timeStamp = Get-TimeStamp
    <#
    if($Message.GetType().name -ne "String"){
        $Message.ToString()
    }
    #>

    #dynamic column creation
    $columnsToAdd = $PSBoundParameters.GetEnumerator() | Where-Object { $_.Key -like "CustomColumn*" }

    #required columns
    $logEntry = "$($timeStamp)" + $Delimiter + "$($Category)" + $Delimiter

    #optional columns
    if ($columnsToAdd.length -ge 1) {
        foreach ($column in $columnsToAdd.GetEnumerator()) {
            $logEntry = $logEntry + "$($column.value)" + $Delimiter
        }
    }
    #final log entry
    $logEntry = $logEntry + $Message

    #if verbose print to screen
    if ($isVerbose) {
        Write-Output $logEntry
    }
    #if logging to file
    if ($global:runningDelimitLogger.toFile) {
        Add-Content -Path $global:runningDelimitLogger.toFileLogPath -Value $logEntry
        return
    }
    #if logging to array
    $global:runningDelimitLogger.logArray += $logEntry
    return
}
function Get-DelimitLogger {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('LogFile', 'Array')]
        $InputType,
        $Array = $false,
        $InternalArray = $false,
        $FilePath,
        $GetLast = $false
    )
    # Set log variable depending on input
    if($input -eq 'LogFile'){ $logs = Get-Content $FilePath } #import log file
    if($InternalArray){$logs = $global:runningDelimitLogger.logArray} #use global array
    if($false -ne $Array){$logs = $Array} #use passed in array

    # Get last entry
    if ($GetLast) {
        return $logs[-1]
    }

    #Use full log
    $logArray = @()
    #make log into objects
    ForEach($log in $logs){
        $log = $log.split('~')
        $logObject = New-Object PSObject
        $i = 0
        foreach($column in $log){
            switch ($i){
                0 { $logObject | Add-Member -MemberType Noteproperty -Name 'TimeStamp' -Value $log[$i] }
                1 { $logObject | Add-Member -MemberType Noteproperty -Name 'category' -Value $log[$i]}
                Default { $logObject | Add-Member -MemberType Noteproperty -Name "column$($i-1)" -Value $log[$i]}
            }
            $i++
        }
        $logArray += $logObject
    }
    return $logArray
}
function Get-TimeStamp {
    return "{0:MM/dd/yy} {0:HH:mm:ss}" -f (Get-Date)
}
function Get-DelimitLoggerDetails {
    param(
        $InputObject,
        [ValidateSet('ERROR', 'INFO', 'SUCCESS', 'WARNING','STATS')]
        $Category
    )

    if($Category -like "*STATS*"){
        $statError = ($InputObject | Where {$_.category -like "*ERROR*"}).category.count
        $statSuccess = ($InputObject | Where {$_.category -like "*SUCCESS*"}).category.count
        $statWarning = ($InputObject | Where {$_.category -like "*WARNING*"}).category.count
        $statsNotInfo = ($InputObject | Where {$_.category -notlike "*INFO*"}).category.count
        $returnMessage = @"
[Logger Details]

Total ERROR:   $statError
Total WARNING: $statWarning
Total SUCCESS: $statSuccess

ERROR rate: $($statError / $statsNotInfo * 100)%
WARNING rate: $($statWarning / $statsNotInfo * 100)%
SUCCESS rate: $($statSuccess / $statsNotInfo * 100)%

Log Start: $($InputObject[0].TimeStamp)
Log End: $($InputObject[-1].TimeStamp)
"@
        return $returnMessage
    }

    $statPull = $InputObject | Where {$_.category -like "*$Category*"}
    return $statPull
}
