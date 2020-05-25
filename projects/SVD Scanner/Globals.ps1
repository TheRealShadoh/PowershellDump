#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------
function Start-Runspace3
{
<#
	.SYNOPSIS
		Created: Christian Crill
		Date: 22 May 2017
		Multithread your scripts!
	
	.DESCRIPTION
		Leverage the power of runspaces to quickly execute a script or scriptblock.
		Pass this function the script or scriptblock, as well as the target for it to run against.
		Ensure that each entry is on its own line. And if you are passing an array of objects, make sure you pass the correct object, IE.. $computers.name
		Within your scriptblock, you should print the information you desire to the console, I recommend using a PSCustomObject and printing an object to the console.
	
	.PARAMETER Target
		Computer name of your target, or a list of your targets. Currently not accepting pipeline input.
	
	.PARAMETER Scriptblock
		Pass your scriptblock in here, or the path to your script.
		Your scriptblock should be written as if it was running independently, do not reference anything outside of the scriptblock, the only exception is the remote computer name you are targetting (See NOTE below).
		NOTE: In your scriptblock anytime you reference the computername, be sure to use $args[0]. This is the only argument that is passed into the runspace.
	
	.PARAMETER Timeout
		Set your timeout period, in minutes, default is 5 minutes.
	
	.PARAMETER Maxthreads
		Set that max amount of threads you want to allow, default is 100.
	
	.NOTES
		Use at your own risk.
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, overriding the timeout to 8 minutes, with a max thread count of 65.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -Timeout 8 -MaxThreads 65
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, overriding the timeout to 8 minutes.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -Timeout 8
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, with a max thread count of 200.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -MaxThreads 200
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, keeping the default 5 minute timeout and 100 threads
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock 
	.EXAMPLE
	This executes the same way as above. Targeting $Computer variable, with the $MyScriptBlock variable, keeping the default 5 minute timeout and 100 threads
		Start-Runspace $Computers $MyScriptBlock 
#>
	
	[CmdletBinding()]
	[OutputType([array])]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$Target,
		[Parameter(Mandatory = $true)]
		$Scriptblock,
		[int64]$Timeout,
		[int64]$Maxthreads
	)
	
	# INITIALIZE
	begin
	{
		if ($Maxthreads.length -gt 1)
		{
			$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Maxthreads)
			$RunspacePool.Open()
			
		}
		Else
		{
			$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, 100)
			$RunspacePool.Open()
		}
	}
	# DURING
	Process
	{
		$Jobs = foreach ($comp in $Target)
		{
			$Job = [powershell]::Create().AddScript($ScriptBlock).AddArgument($comp)
			$Job.RunspacePool = $RunspacePool
			[PSCustomObject]@{
				Pipe = $Job
				Timer = Get-Date
				Result = $Job.BeginInvoke()
			}
			
		}
	}
	# END
	End
	{
		Do
		{
			foreach ($Job in $Jobs | where { $__.Result.IsCompleted -eq $false })
			{
				if ($Timeout -ne $null)
				{
					If (((Get-Date) - ($Job.timer)).Minutes -ge $Timeout)
					{
						$Job.Result.IsCompleted = $true
					}
					
				}
				Else
				{
					If (((Get-Date) - ($Job.timer)).Minutes -ge 6)
					{
						$Job.Result.IsCompleted = $true
					}
				}
			}
		}
		While
		(
			$Jobs.Result.IsCompleted -contains $false
		)
		$RunspacePool.Close()
		foreach ($Job in $Jobs)
		{
			$Job.Pipe.Endinvoke($Job.Result)
			$Job.pipe.close
			$Job.dispose
		}
	}
}
function Start-Runspace
{
<#
	.SYNOPSIS
		Created: Christian Crill
		Date: 22 May 2017
		Multithread your scripts!
	
	.DESCRIPTION
		Leverage the power of runspaces to quickly execute a script or scriptblock.
		Pass this function the script or scriptblock, as well as the target for it to run against.
		Ensure that each entry is on its own line. And if you are passing an array of objects, make sure you pass the correct object, IE.. $computers.name
		Within your scriptblock, you should print the information you desire to the console, I recommend using a PSCustomObject and printing an object to the console.
	
	.PARAMETER Target
		Computer name of your target, or a list of your targets. Currently not accepting pipeline input.
	
	.PARAMETER Scriptblock
		Pass your scriptblock in here, or the path to your script.
		Your scriptblock should be written as if it was running independently, do not reference anything outside of the scriptblock, the only exception is the remote computer name you are targetting (See NOTE below).
		NOTE: In your scriptblock anytime you reference the computername, be sure to use $args[0]. This is the only argument that is passed into the runspace.
	
	.PARAMETER Timeout
		Set your timeout period, in minutes, default is 5 minutes.
	
	.PARAMETER Maxthreads
		Set that max amount of threads you want to allow, default is 100.
	
	.NOTES
		Use at your own risk.
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, overriding the timeout to 8 minutes, with a max thread count of 65.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -Timeout 8 -MaxThreads 65
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, overriding the timeout to 8 minutes.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -Timeout 8
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, with a max thread count of 200.
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock -MaxThreads 200
	.EXAMPLE
	Targeting $Computer variable, with the $MyScriptBlock variable, keeping the default 5 minute timeout and 100 threads
		Start-Runspace -Target $Computers -Scriptblock $MyScriptBlock 
	.EXAMPLE
	This executes the same way as above. Targeting $Computer variable, with the $MyScriptBlock variable, keeping the default 5 minute timeout and 100 threads
		Start-Runspace $Computers $MyScriptBlock 
#>
	
	[CmdletBinding()]
	[OutputType([array])]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$Target,
		[Parameter(Mandatory = $true)]
		$Scriptblock,
		[int64]$Timeout,
		[int64]$Maxthreads
	)
	
	# INITIALIZE
	begin
	{
		if ($Maxthreads.length -gt 1)
		{
			$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Maxthreads);
			$RunspacePool.Open();
			
		}
		Else
		{
			$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, 100)
			$RunspacePool.Open();
		}
	}
	# DURING
	Process
	{
		$Jobs = @()
		Foreach ($comp in $Target)
		{
			$Job = [powershell]::Create().AddScript($ScriptBlock).AddArgument($comp);
			$Job.RunspacePool = $RunspacePool;
			$JobTask = New-Object PSCustomObject
			$JobTask | Add-Member -MemberType NoteProperty -Name Pipe -Value $Job
			$JobTask | Add-Member -MemberType NoteProperty -Name Timer -Value Get-Date
			$JobTask | Add-Member -MemberType NoteProperty -Name Result -Value $Job.BeginInvoke()
			$Jobs += $JobTask
		}
	}
	# END
	End
	{
		Do
		{
			foreach ($Job in $Jobs | where { $__.Result.IsCompleted -eq $false })
			{
				if ($Timeout -ne $null)
				{
					If (((Get-Date) - ($Job.timer)).Minutes -ge $Timeout)
					{
						$JobTask.Result.IsCompleted = $true;
					}
					
				}
				Else
				{
					If (((Get-Date) - ($Job.timer)).Minutes -ge 6)
					{
						$JobTask.Result.IsCompleted = $true;
					}
				}
			}
		}
		While
		(
			$JobTask.Result.IsCompleted -contains $false
		)
		$RunspacePool.Close()
		foreach ($Job in $Jobs)
		{
			#$Job.Pipe.EndInvoke($Job.Result);
			$Job.Pipe.EndInvoke($Job.Result)
			$Job.Pipe.Close | Out-Null
			$Job.Pipe.Dispose | Out-Null
		}
	}
}

function Test-ADAuthentication
{
	param (
		$username,
		$password
	)
	(New-Object System.DirectoryServices.DirectoryEntry "", $username, $password).psbase.name -ne $null
}
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

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

function Get-ADComputer-LDAP
{
	param(
		
	)
	
	$CurrentDomain = $env:USERDNSDOMAIN
	
	IF ($CurrentDomain.Split(".").count -eq 4)
	{
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3])")
	}
	IF ($CurrentDomain.Split(".").count -eq 5)
	{
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3]),DC=$($($CurrentDomain).split(".")[4])")
	}
	
	$searcher = New-Object System.DirectoryServices.DirectorySearcher($root)
	$searcher.Filter = "(objectCategory=computer)"
	$searcher.PageSize = 1000
	$searcher.PropertiesToLoad.Add("name")
	$comps = $searcher.FindAll()
	$comps.Properties.name
}

