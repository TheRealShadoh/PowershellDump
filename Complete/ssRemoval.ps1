Add-PSSnapin VMware.VIMAutomation.Core
$creds = Get-Credential
Connect-VIServer "IP ADDRESS OF VC" -Credential $creds

$vms = Get-VM

foreach ($obj in $vms)
{
	while ((get-task -status Running | where {$_.name -eq "RemoveSnapshot_Task"}).count -gt 10)
	{
		Start-Sleep -Seconds 30
	}
	Get-Snapshot -VM $obj | Where {$_.IsCurrent -eq $false} | Remove-Snapshot -Confirm:$false -RunAsync
}
Disconnect-VIServer