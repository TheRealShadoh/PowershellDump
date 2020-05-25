function Find-LogonAsService {
    [CmdletBinding()]
    param (
    )

    # Defaults from Windows
    $ignoreAccounts = @("LocalSystem", "NT Authority\LocalService", "NT Authority\Local Service", "NT AUTHORITY\NetworkService", "NT AUTHORITY\Network Service")
    $accounts = @("NT SERVICE\ALL SERVICES")

    # Accounts that >enabled< services should run under. Only doing enabled services.
    $accounts += Get-WmiObject -Class Win32_Service | Where { $_.StartMode -ne "Disabled" } | Select-Object -ExpandProperty StartName

    # Look for special groups created for SQL Server
    $accounts += Get-WmiObject -Class Win32_Account -Namespace "root\cimv2" -Filter "LocalAccount=True" | Where { ($_.SIDType -ne 1 -or !$_.Disabled) -and $_.Name -like "SQLServer*User$*" } | Select-Object -ExpandProperty Name

    # IIS AppPool entities
    try {
		# Try to import the webadmin module that is included when IIS is installed on a system. If it failes then IIS not installed. So don't look for seaccounts
		Import-Module WebAdministration
        Get-ChildItem IIS:\AppPools | % {
            $accounts += "IIS APPPOOL\$($_.Name)"
        }
    } catch {
		#Write-Warning "** No IIS, or PowerShell not running as Administrator: $_"
		Write-Warning "** No IIS installed on this system, or PowerShell not running as Administrator."
    }

    # LocalSystem can be ignored, as it's really NT Authority\SYSTEM, which will
    # be covered by other accounts (like ALL SERVICES).sq,ser
    $accounts | Sort -Unique | Where { $ignoreAccounts -notcontains $_ }
}
