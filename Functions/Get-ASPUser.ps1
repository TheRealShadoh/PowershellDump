
Function Get-ASPUser {
    <#
    .SYNOPSIS
    Pulls down ADUC information from target ASP, using the PoSH Active Directory Module
    .DESCRIPTION
    Asks for credentials based on the target ASP. Then pulls all of the ASP information down for ALL users in the ASP domain.
    Due to a bug in Get-ADUser which causes PoSH to slow down when results are saved in an object or an array, I've had the
    function write to a csv file/Import the csv file/then delete the csv file. This allows for quick data processing, while
    allowing you to manipulate the results however you wish.
    .EXAMPLE
    Call the function, give your username, give it the ASP number, give it the IP of the target domain controller.
    .EXAMPLE
    Get-ASPUser Username 99 x.x.55.555
    .PARAMETER Account
    Enter the desired username do NOT add the @ASP
    .PARAMETER ASP
    Enter the NUMBERS for the ASP
    .PARAMETER DC
    Enter the full IP address of the target DC, include the periods
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True)]
        $Account,
        $ASP,
        $DC
        )
    $GetCred = Get-Credential -UserName "ASP$($ASP)\$Account" -Message "Enter the appropriate credentials for: ASP$($ASP)"
    Get-ADUser -Filter * -Server $DC -Credential $GetCred -Properties * | Export-Csv "C:\Windows\Temp\Get-ASPUser-$ASP-Temp.csv" -Force
    Import-Csv "C:\Windows\Temp\Get-ASPUser-$ASP-Temp.csv"
    Remove-Item "C:\Windows\Temp\Get-ASPUser-$ASP-Temp.csv"
}