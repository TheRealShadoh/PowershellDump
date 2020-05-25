Function Wait-VMOffline
{
	Param ($TargetGroup)
	
	$i = 0
	Do
	{
		$Working_Array = @()
		Foreach ($obj in $TargetGroup)
		{
			$i++
			$SubObj = New-Object PSObject
			$VMStatus = (Get-VM -Name $obj)
			$VMTools = (get-vm -Name $obj).guest.extensiondata.ToolsStatus
			$SubObj | Add-Member -MemberType NoteProperty -Name Name -Value $VMStatus.Name
			$SubObj | Add-Member -MemberType NoteProperty -Name PowerState -Value $VMStatus.PowerState
			$SubObj | Add-Member -MemberType NoteProperty -Name Tools -Value $VMTools
			If ($VMStatus.PowerState -eq "PoweredOn")
			{
				$Working_Array += $SubObj
			}
			If ($VMTools -eq "toolsNotInstalled")
			{
				Stop-VM -VM $Obj -confirm:$false
			}
			IF ($i -ge 120)
			{
				break
			}
		}
		
		Start-Sleep -Seconds 1
	}
	Until ([int]$Working_array.count -eq 0)
}
