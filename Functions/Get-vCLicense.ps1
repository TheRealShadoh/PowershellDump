Function Get-vCLicense {
    <#
    .SYNOPSIS
    Gathers Licenses from vCenter for each associated ESXi host.
    .DESCRIPTION
    Asks for credentials based on the target ASP. Connects to the ASP vCenter and gathers the license information.
    .EXAMPLE
    Call the function, give your username, give it the ASP number, give it the IP of the target vCenter Server.
    .EXAMPLE
    Get-vCLicense Username 99 x.x.55.555
    .PARAMETER Account
    Enter the desired username do NOT add the @ASP
    .PARAMETER ASP
    Enter the NUMBERS for the ASP
    .PARAMETER DC
    Enter the full IP address of the target VC, include the periods
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True)]
        $Account,
        $ASP,
        $DC
        )
    $GetCred = Get-Credential -UserName "$Account@ASP$ASP" -Message "Enter the appropriate credentials for: ASP$($ASP)"
    $Array = @()
    Add-PSSnapin VMWare.VIMAutomation.Core
    Connect-VIServer "$VC" $GetCred
    $ServiceInstance = Get-View ServiceInstance
    Foreach ($LicenseMan in Get-View ($ServiceInstance | Select -First 1).Content.LicenseManager){
        $Object = [PSCustomObject] @{
            ASP = "ASP$ASP"
            VC = ([Uri]$LicenseMan.Client.ServiceURL).Host
            Lic_Name = $License.Name
            Key = $License.LicenseKey
            Total = $License.Total
            Used = $License.Used
            Information = $License.Labels | Select -Expand Value
            ExpirationDate = $License.Properties | Where {$_.key -eq "ExpirationDate"} | Select -ExpandProperty Value
            }
        $Array += $Object | Select ASP, VC, Lic_Name, Key, Total, Used, ExpirationDate, Information 
    }
    Disconnect-VIServer
}