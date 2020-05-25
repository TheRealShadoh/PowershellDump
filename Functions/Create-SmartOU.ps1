Function Create-SmartOU {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
        Write-Host "Creating OU: $Name" -ForegroundColor Cyan -BackgroundColor Gray
            Try {
                New-ADOrganizationalUnit -Name "$Name" -Path "$Path"
                "Created: $Name" >> "$($LogPath)Create_OU_Log.txt"
            }
            Catch {
                Write-Warning "$($Error.exception.message)"
                "Failed: $Name : $($Error.exception.message)" >> "$($LogPath)Create_OU_Log.txt"
                $error.clear()
                Read-Host "Press Enter when ready to continue / OR / Stop the script and correct the issue"
            }
}