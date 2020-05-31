import-module C:\git\PowershellDump\Functions\delimitLogger.psm1 -Verbose -Force

Start-DelimitLogger
New-DelimitLogger -Category INFO -Message "test" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang"
New-DelimitLogger -Category INFO -Message "verbose" -CustomColumn1 "blah" -CustomColumn2 "booo" -CustomColumn3 "bang" -isVerbose $true

Get-DelimitLogger
Stop-DelimitLogger