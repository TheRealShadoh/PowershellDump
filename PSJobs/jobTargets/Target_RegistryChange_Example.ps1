#===========================================================================
#  .ORIGIN
#
#===========================================================================
#  .DESCRIPTION
#
# Example of a target script for a SCHTASK script
#
# Changes registry value NETLOGON\ImagePath and Services\SamSs
# Then restarts the Server and NetLogon Service
# Machine will then restart
#
#

$RegPath = "SYSTEM\CurrentControlSet\services"
$Reg = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer)
$RegKey = $Reg.OpenSubKey($RegPath)
$SubKeys = $RegKey.GetSubKeyNames()
ForEach ($SubKey in $SubKeys) {
    $Key = $RegPath + "\" + $SubKey
    $ThisSubKey = $Reg.OpenSubKey($Key)
    $KeyPath = "HKLM:\" + $Key
    $OldPath = $ThisSubKey.GetValue("ImagePath", $null, 'DoNotExpandEnvironmentNames')
    If ($Key -like "SYSTEM\CurrentControlSet\Services\Netlogon") {
        $NewPath = "%systemroot%\system32\lsass.exe"
        Set-ItemProperty -Path $KeyPath -Name "ImagePath" -Value $NewPath -Force
    }

    If ($Key -like "SYSTEM\CurrentControlSet\Services\SamSs") {
        $NewPath = "%SystemRoot%\system32\lsass.exe"
        Set-ItemProperty -Path $KeyPath -Name "ImagePath" -Value $NewPath -Force
    }
}

#
# Start services and restart the machine
#
Start-Sleep -Seconds 5
Start-Service -Name Server
Start-Service -Name Netlogon
Shutdown /r /f /t 300