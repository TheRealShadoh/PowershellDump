function Grant-LogOnAsService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $User
    )
   
    begin {
        $secedit = "C:\Windows\System32\secedit.exe"
        $gpupdate = "C:\Windows\System32\gpupdate.exe"
        $seceditdb = "$($env:TEMP)\secedit.sdb"

        $oldSids = ""
        $newSids = ""
        $secfileInput = [System.IO.Path]::GetTempFileName()
        $secfileOutput = [System.IO.Path]::GetTempFileName()

        # Get list of currently used SIDs 
        &$secedit /export /cfg $secfileInput | Write-Debug

        # Find the line with existing SIDs if it exists
        if (((Get-Content $secfileInput) -join [Environment]::NewLine) -match "SeServiceLogonRight = (.*)") {
            $oldSids = $Matches[1]
        }
    }

    process {
        # Try to convert each account name to *SID, otherwise just use the account name
        try {
            $userAccount = New-Object System.Security.Principal.NTAccount($User)
            $userTranslated = "*$($userAccount.Translate([System.Security.Principal.SecurityIdentifier]))"
        } catch {
            $userTranslated = $User
        }

        # Only add it to the list if neither SID nor name exist already
        if (!$oldSids.Contains($userTranslated) -and !$oldSids.Contains($User)) {
            $PSCmdlet.ShouldProcess($User) | Out-Null

            if ($newSids) {
                $newSids += ",$userTranslated"
            } else {
                $newSids += $userTranslated
            }
        }
    }

    end {
        # Only update if new SIDs are needed
        if ($newSids) {
            # Concatenate existing SIDs
            if ($oldSids) {
                $allSids = $oldSids + "," + $newSids
            } else {
                $allSids = $newSids
            }

            # Replace the section with the concatenated SID list, or add a new one
            $secFileContent = Get-Content $secfileInput | %{
                if ($oldSids -and $_ -match "SeServiceLogonRight = (.*)") {
                    "SeServiceLogonRight = $allSids"
                } else {
                    $_

                    if ($_ -eq "[Privilege Rights]" -and !$oldSids) {
                        "SeServiceLogonRight = $allSids"
                    }
                }
            }

            Set-Content -Path $secFileOutput -Value $secFileContent -WhatIf:$false

            # If we're really doing it, make the change
			if (!$WhatIfPreference) {
				# Write-Verbose "Would have done stuff here"
                &$secedit /import /db $seceditdb /cfg $secfileOutput
                &$secedit /configure /db $seceditdb | Write-Debug
                Remove-Item $seceditdb
                &$gpupdate /force | Write-Debug
            }
        } else {
            Write-Verbose "No change"
        }
    
        Remove-Item $secfileInput -WhatIf:$false
        Remove-Item $secfileOutput -WhatIf:$false
#		start notepad.exe "$secfileInput"
#		start notepad.exe "$secfileOutput"
    }
}