
Function Start-VMQuestions
{
	Param ($TargetGroup)
	$Working_Array = @()
	Foreach ($obj in $TargetGroup)
	{
		$ErrorActionPreference = "Stop"
		$error.clear()
		$SubObj = New-Object PSObject
		Try
		{
			Start-VM -VM $obj -RunAsync -Confirm:$false
		}
		Catch
		{
			IF ($error -like "*Another task is already in progress.*")
			{
			}
			IF ($error -like "*Question*")
			{
				$SubObj | Add-Member -MemberType NoteProperty -Name Name -Value $obj
				$Working_Array += $SubObj
				Get-VM -Name $obj | Get-VMQuestion | Set-VMQuestion -Option "Button.uuid.Cancel" -Confirm:$false
			}
			If ($error -like "*PowerState*")
			{
			}
		}
		
		$ErrorActionPreference = "Continue"
	}
	IF ($Working_Array.count -gt "0")
	{
		$Working_Array
		Start-Sleep -seconds 2
	}
}