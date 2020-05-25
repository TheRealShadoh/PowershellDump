Function Get-vCLicense {
    <#
    .SYNOPSIS
    Gathers Licenses from vCenter for each associated ESXi host.
    .EXAMPLE
    Call the function, give your username, give it the ASP number, give it the IP of the target vCenter Server.
    .EXAMPLE
    Get-vCLicense Username x.x.55.555
    .PARAMETER Account
    Enter the desired username
    .PARAMETER VC
    Enter the full IP address of the target VC, include the periods
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        $VC
    )
    $GetCred = Get-Credential -Message "Enter the appropriate credentials."
    $Array = @()
    Add-PSSnapin VMWare.VIMAutomation.Core
    Connect-VIServer "$VC" $GetCred
    $ServiceInstance = Get-View ServiceInstance
    Foreach ($LicenseMan in Get-View ($ServiceInstance | Select -First 1).Content.LicenseManager) {
        $Object = [PSCustomObject] @{
            VC             = ([Uri]$LicenseMan.Client.ServiceURL).Host
            Lic_Name       = $License.Name
            Key            = $License.LicenseKey
            Total          = $License.Total
            Used           = $License.Used
            Information    = $License.Labels | Select -Expand Value
            ExpirationDate = $License.Properties | Where { $_.key -eq "ExpirationDate" } | Select -ExpandProperty Value
        }
        $Array += $Object | Select VC, Lic_Name, Key, Total, Used, ExpirationDate, Information
    }
    Disconnect-VIServer
}