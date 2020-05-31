function Start-DelimitLogger {
    <#
    Create global variable to record logging status to an array or to a file, store file path and array here.
    Allows new-delimit logger to not care about being told the log file path or array to store the logs in
    #>
    param(
        [ValidateSet('TRUE','FALSE')]
        $ToFile,
        $LogFilePath
    )

    if($ToFile){
        New-Item -Path $LogFilePath -Force
        $global:runningDelimitLogger = @{"running" = $true; "toFile" = $true; "toFileLogPath" = $LogFilePath; "toArray" = $false}
        return $true
    }

    $global:runningDelimitLogger = @{"running" = $true; "toFile" = $false; "toFileLogPath" = $false; "toArray" = $true; "logArray" = @()}

}
function Format-DelimitLogger {
    <#
    Read in the array or text file and identify the requierd columns, as well as the custom columns. Pump out basic stats about each one.
    Plan to leverage this for UI log viewing and tailing
    #>

    param()
}

function Process-DelimitLogger {
    <#
    Based on log type, print the array or tell the file path.
    Set running to false
    #>

    param()
    if($global:runningDelimitLogger.toArray){
        $global:runningDelimitLogger.running = $false
        return $global:runningDelimitLogger.logArray
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
        [string]$Delimiter = "::",
        [Parameter(Mandatory)]
        [ValidateSet('ERROR','INFO','SUCCESS','WARNING','VERBOSE')]
        [string]$Category,
        $Message,
        [string]$CustomColumn1,
        [string]$CustomColumn2,
        [string]$CustomColumn3,
        [string]$CustomColumn4,
        [string]$CustomColumn5,
        [ValidateSet('TRUE','FALSE')]
        $isVerbose
    )

    if(-not ($global:runningDelimitLogger.running)){
        return Write-Warning "Must run Start-DelimitLogger first!"
    }


    #get timestamp / force message string
    $timeStamp = Get-TimeStamp
    if($Message.GetType().name -ne "String"){
        $Message.ToString()
    }

    #dynamic column creation
    $columnsToAdd = $PSBoundParameters.GetEnumerator() | Where-Object {$_.Key -like "CustomColumn*"}

    #required columns
    $logEntry = "[$($timeStamp)]" + $Delimiter + "[$($Category)]" + $Delimiter

    #optional columns
    foreach ($column in $columnsToAdd.GetEnumerator()){
        $logEntry = $logEntry + "[$($column.value)]" + $Delimiter
    }
    #final log entry
    $logEntry = $logEntry + $Message

    #if verbose print to screen
    if($isVerbose){
        Write-Output $logEntry
    }
    #if logging to file
    if($global:runningDelimitLogger.toFile){
        Add-Content -Path $global:runningDelimitLogger.toFileLogPath -Value $logEntry
        return
    }
    #if logging to array
    $global:runningDelimitLogger.logArray += $logEntry
    return
}
function Get-DelimitLogger {
    param(
        # option or last entry or range should go here...
    )
    if($global:runningDelimitLogger.toArray){
        return $global:runningDelimitLogger.logArray[-1] #return last entry
    }

    return Write-Warning "Not logging to an array"

}
function Get-TimeStamp {
    return "{0:MM/dd/yy} {0:HH:mm:ss}" -f (Get-Date)
}