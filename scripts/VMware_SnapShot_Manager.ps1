<#  .DESCRIPTION
    Connects to target vCenter using the PowerCLI SnapIn.
    Lists the current Snapshots and their associated VMs, Created Date,
    and if they're the current Snapshot.

    .EXAMPLES
    1. Create a snapshot on ALL VMs
    2. Delete ALL snapshots on ALL VMs
    3. Delete all of the NON-current snapshots on all VMs
    4. Exit and do nothing
#>

# SETUP
$nl = [Environment]::newline
$continue = $false
$error.clear()

# BEGIN
Write-Host "Adding PowerCLI SnapIn" -ForegroundColor Cyan -BackgroundColor DarkGray
Try {
    Add-PSSnapin VMware.VIMAutomation.Core
}
Catch {
    Write-Warning "$($Error.exception.message)"
    $error.clear()
}
$nl
$nl
$nl
$vCenter = Read-Host "Enter the vCenter IP: "
Write-Host "Connecting to vCenter: $vCenter" -ForegroundColor Cyan -BackgroundColor DarkGray
Try {
    Connect-VIServer "$vCenter"
}
Catch {
    Write-Warning "$($Error.exception.message)"
    $error.clear()
}

Write-Host "Checking for Snapshot Status" -ForegroundColor Cyan -BackgroundColor DarkGray
$Hosts = Get-VM | Get-Snapshot | Select VM, Name, Created, IsCurrent

$nl
$nl
$nl
$Hosts | ogv
$nl
$nl
$nl
# BODY
Do {
    Write-Host "Scan complete, you may now exit, or make changes below." -ForegroundColor Cyan -BackgroundColor DarkGray


    "1. Create New Snapshot on all hosts"
    "2. Delete (ALL)Snapshots on all hosts"
    "3. Delete Non-Current Snapshots on all hosts"
    "4. Exit and do nothing"
    $Ans = Read-Host "Enter your Selection"

    IF ($ans -eq "1") { #Create New Snapshot on all hosts
        $AnsName = Read-Host "What Should the Snapshot be named?"
        Get-VM | New-Snapshot -Name "$AnsName" -RunAsync -Confirm:$False
        $continue = $true
    }
    IF ($ans -eq "2") { #Delete (ALL)Snapshots on all hosts
        Get-VM | Get-Snapshot | Remove-Snapshot -RunAsync -Confirm:$False -RemoveChildren
        $continue = $true
    }
    IF ($ans -eq "3") { #Delete Non-Current Snapshots on all hosts
        Get-VM | Get-Snapshot | Where { $_.isCurrent -eq "False" } | Remove-Snapshot -RunAsync -Confirm:$False
        $continue = $true
    }
    IF ($ans -eq "4") { #Exit and do nothing
        $continue = $true
    }
}
Until ($continue = $true)
# END
$nl
$nl
$nl
$Hosts = Get-VM | Get-Snapshot | Select VM, Name, Created, IsCurrent
$Hosts | ogv

Write-Host "Disconnecting from $vCenter" -ForegroundColor Cyan -BackgroundColor DarkGray
Disconnect-VIServer -Server $vCenter -Confirm:$false
