import-module C:\git\PowershellDump\Functions\delimitLogger.psm1 -Verbose -Force
<#
Start-DelimitLogger
New-DelimitLogger -Category INFO -Message "test" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category WARNING -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category SUCCESS -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"

$a = Get-DelimitLogger -InputType Array -InternalArray $true
Get-DelimitLoggerDetails -Category Stats -InputObject $a
Stop-DelimitLogger
#>

Start-DelimitLogger -ToFile $true -LogFilePath ".\test.log"
New-DelimitLogger -Category INFO -Message "test" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category ERROR -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category WARNING -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category SUCCESS -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"

$a = Get-DelimitLogger -InputType LogFile -FilePath $global:runningDelimitLogger.toFileLogPath
Get-DelimitLoggerDetails -Category Stats -InputObject $a
Stop-DelimitLogger