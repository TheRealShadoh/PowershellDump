cls
<#  .DESCRIPTION
    Script asks for which ASP you will be accessing, then asks which account you will be using.
    This is to fill out the credential screen and save you typing. After this it will pull down a 
    list of service accounts within the service accounts OU for you to validate your targets, this 
    script will hit EVERY account listed. It will then ask for your new password twice, it runs validation
    on the password to ensure you enter the same case-sensitive password. Upon completion it will
    show you the accoutns modified, pay attention to the Password Last Set option. 
#>

# SETUP
$nl = [Environment]::newline
$continue = $false 
$date = Get-Date -UFormat "%d-%b-%g %H%M"

# BEGIN
$ASP = Read-Host "Which ASP will you be accessing? Example:  ASP##"
$Account = Read-Host "Which account will you be logging in with? Example:  sa.example.user"
$DC = Read-Host "What is the full IP of the target Domain Controller?"
cls

# BODY
$nl
$nl
$nl
$ServiceAccounts = Get-ADUser -filter * -Server $DC -Searchbase "OU=Service Accounts,OU=Admins,OU= ,DC=$ASP,DC=,DC=,DC=" -Properties *
$ServiceAccounts| Select Name, PasswordLastSet, LockedOut, PasswordExpired, PasswordNeverExpires, PasswordNotRequired |Format-Table -AutoSize
$nl
$nl
Write-Host "Target ASP:  $ASP" -ForegroundColor DarkYellow
Write-Host "Account to be used:  $Account" -ForegroundColor DarkYellow
Write-Host "IP for target Domain Controller:  $DC" -ForegroundColor DarkYellow
$nl
$nl
Do { #Check your targets, option to cancel the script here
    Write-Host "Review the above settings and target accounts. Would you like to continue?" -ForegroundColor Cyan -BackgroundColor DarkGray
    $Ans = Read-Host "Enter Yes or No"
    IF ($Ans -eq "yes") {
        $continue = $true
    }
    IF ($Ans -eq "no") {
        exit
    }
}
Until ($continue -eq $true)
$continue = $false
cls

$GetCred = Get-Credential -UserName "$ASP\$Account" -Message "Enter the appropriate credentials for: $ASP" #Gathers administrative permissions
Write-Host "Validating Password to be used" -ForegroundColor Cyan -BackgroundColor DarkGray

Do { #Password validation
    $NewPassword_1 = Read-Host "Enter New Password" -AsSecureString
    Start-Sleep -Seconds 1
    $NewPassword_2 = Read-Host "Re-enter New Password " -AsSecureString
    $NewPassword_1_Text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword_1))
    $NewPassword_2_Text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword_2))
    IF ($NewPassword_1_Text -ceq $NewPassword_2_Text){
        $continue = $true
    } Else {
        Write-Warning "PASSWORD  Mismatch"
    }
    $NewPassword_1_Text = $null
    $NewPassword_2_Text = $null
}
Until ($continue -eq $true)

Foreach ($ServiceAccount in $ServiceAccounts.Name) { #Password change occurs here
    Write-Host "Changing Password on $ServiceAccount" -ForegroundColor DarkYellow
    Set-ADAccountPassword -Credential $GetCred -Server $DC -Identity $ServiceAccount -NewPassword $NewPassword_1 -Reset 
}


Write-Host "Results"  -ForegroundColor Red -BackgroundColor Yellow #Display results
$ServiceAccounts = Get-ADUser -filter * -Searchbase "OU=Service Accounts,OU=Admins,OU= ,DC=$ASP,DC=,DC=,DC=" -Properties *
$ServiceAccounts| Select Name, PasswordLastSet, LockedOut, PasswordExpired, PasswordNeverExpires, PasswordNotRequired |Format-Table -AutoSize

# END
Do { #Option to export results to a log file
    Write-Host "Review the above results"
    Write-Host "Save results: Yes"
    Write-Host "Exit: No"
    $nl
    $Ans = Read-Host "Enter Yes or No"

    IF ($Ans -eq "yes") {
        Do {
            $path = Read-Host "Enter the full path for your log to be saved, do NOT add the last \. Example. C:\Users\sa.test.user\desktop"
            $test = Test-Path $path
        }
        Until ($test -eq $true)
        $ServiceAccounts | Export-csv -append "$path\Service_Account_PassChange_$date.csv" -Force
        $continue = $true
    }
    IF ($Ans -eq "no") {
        $continue = $true
    }
}
Until ($continue -eq $true)

