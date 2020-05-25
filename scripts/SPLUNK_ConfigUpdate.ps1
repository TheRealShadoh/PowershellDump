<#
	.DESCRIPTION
		Targets to whole domain
		Only updates machines that already have the configuration file
	.REQUIRES
		Get-ADComputer-LDAP
		Start-Runspace
	FIELDS TO UPDATE
		Update the $ConfPath to match the path of the conf file, leave the \\$($args[0])\c$\ portion

		Update the lines you need changed, look for the comment "Overwrite at indexed path"
		To update the specific line enter the lines index [0], [1], [2], etc...

		Update the lines you need added, look for the comment "Insert line below index"
		Enter the index of the line above where your line should be [0], [1], [2], etc...
			Update the index on both references, then place your new text after the `r`n
			Directly after the `r`n do not leave a space after the `r`n
#>

# Gather Targets
$comps = Get-ADComputer-LDAP

$Scriptblock = {
	# Path of configuration file
	$ConfPath = "\\$($args[0])\c$\Users\Administrator\Desktop\Scripts\Development\CONF TEST.txt"

	# Check if target is online
	$ping = Test-Connection -ComputerName $args[0] -Count 1 -Quiet

	# Proceed if online
	IF ($ping -eq $true) {
		# Validate if change is needed
		$Valid = Test-Path -Path $ConfPath
	}
	ELSE {
		$Valid = $false
	}
	# IF Valid
	IF ($Valid -eq $true) {
		# Gather contents of configuration File
		$ConfContent = Get-Content -Path $ConfPath

		# Previous File Timestamp
		$OringinalTime = Get-ItemProperty -Path $ConfPath | select Lastwritetime

		# Overwrite at indexed path
		$ConfContent[0] = "hostname = $($env:Computername)"

		# Insert line below index
		$ConfContent[4] = $ConfContent[4] + "`r`nENTERnewDATAhere"

		# Update File
		$ConfUpdate = $ConfContent | Out-File $ConfPath -Force

		# New Timestamp
		$NewTime = Get-ItemProperty -Path $ConfPath | select Lastwritetime

		# Check if updated
		IF ($NewTime.lastwritetime -gt $OringinalTime.lastwritetime) {
			$FileChanged = "Updated"
		}
		ELSE {
			$FileChanged = "Not Changed"
		}

	}

	$Remoteobj = New-Object PSCustomObject
	$Remoteobj | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $args[0]
	$Remoteobj | Add-Member -MemberType NoteProperty -Name "Online" -Value $ping
	$Remoteobj | Add-Member -MemberType NoteProperty -Name "FileChanged" -Value $FileChanged


}

$Outcome = Start-Runspace -Target $Comps -Scriptblock $Scriptblock
