Function Move-SmartOU {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$Source,
        [Parameter(Mandatory=$true)]
        [string]$Destination
   ) 
        Write-Host "Moving OU: $Name" -ForegroundColor Cyan -BackgroundColor Gray
            Try {
                Get-ADComputer -Filter * -SearchBase "$Source" -SearchScope 1 | Move-ADObject -TargetPath "$Destination"
                "Moved: $Name" >> "$($LogPath)Log.txt"
            }
            Catch {
                Write-Warning "$($Error.exception.message)"
                "Failed: $Name : $($Error.exception.message)" >> "$($LogPath)Move_Computer_Log.txt"
                $error.clear()
                Read-Host "Press Enter when ready to continue / OR / Stop the script and correc the issue"
            }
}