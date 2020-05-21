Function Set-ASPAccountPassword {
    <#
    .SYNOPSIS
    Changes the password for a user account on a target ASP.
    .DESCRIPTION
    Asks for credentials based on the target ASP. Requests the password to set on the user account, asks again and validates
    that they are the same password. 
    .EXAMPLE
    Call the function, give your username, give it the ASP number, give it the IP of the target domain controller, give the target username.
    .EXAMPLE
    Set-ASPAccountPassword Username 99 x.x.55.555 TargetUser
    .PARAMETER Account
    Enter the desired username do NOT add the @ASP
    .PARAMETER ASP
    Enter the NUMBERS for the ASP
    .PARAMETER DC
    Enter the full IP address of the target DC, include the periods
    .PARAMETER User
    Enter the target username
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True)]
        $Account,
        $ASP,
        $DC,
        $User
        )
    $continue = $false 
    $GetCred = Get-Credential -UserName "ASP$($ASP)\$Account" -Message "Enter the appropriate credentials for: ASP$($ASP)"
    Do {
        $NewPassword_1 = Read-Host "Enter New Password" -AsSecureString
        Start-Sleep -Seconds 1
        $NewPassword_2 = Read-Host "Re-enter New Password " -AsSecureString
        $NewPassword_1_Text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword_1))
        $NewPassword_2_Text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword_2))
        IF ($NewPassword_1_Text -ceq $NewPassword_2_Text){
            $continue = $true
        } Else {
            Write-Warning "PASSWORD  Mismatch"
            Msg Console "Password Mismatch"
        }

    }
    Until ($continue -eq $true)
    $NewPassword = $NewPassword_1
    Set-ADAccountPassword -Credential $Account -Server $DC -Identity $User -NewPassword $NewPassword -Reset

}



