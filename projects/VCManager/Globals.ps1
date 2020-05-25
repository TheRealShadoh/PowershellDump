#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------
#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

Function Wait-VMOffline
{
	Param ($TargetGroup)
	
	Do
	{
		$Working_Array = @()
		Foreach ($obj in $TargetGroup)
		{
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
		}
		
		$Working_Array
		Start-sleep -seconds 2
	}
	Until ([int]$Working_array.count -eq 0)
}

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
