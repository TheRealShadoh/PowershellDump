<#
	.SYNOPSIS
		Created: TheRealShadoh
		Date:

	.DESCRIPTION
    Tries to repair PSRemoting through common fix actions.
#>
function Minion-Enable-PSRemoting-Server {
    param(
        [parameter(Mandatory = $true)]
        $computername
    )
    #const
    $quote = [char]34
    #Remote Commands to execute to enable our flavor of remoting.  To be executed via WMI.
    $command_1 = "schtasks.exe /CREATE /TN 'Minion-Enable-WSRemoting1' /SC ONCE /ST 17:00 /RL HIGHEST /RU SYSTEM /TR $quote powershell.exe -noprofile -command Enable-PSRemoting -Force$quote /F"
    $command_2 = "schtasks.exe /CREATE /TN 'Minion-Enable-WSRemoting2' /SC ONCE /ST 17:00 /RL HIGHEST /RU SYSTEM /TR $quote powershell.exe -noprofile -command Set-WSManQuickConfig -Force$quote /F"
    $command_3 = "schtasks.exe /CREATE /TN 'Minion-Enable-WSRemoting3' /SC ONCE /ST 17:00 /RL HIGHEST /RU SYSTEM /TR $quote powershell.exe -noprofile -command Enable-WSManCredSSP -Role Server -Force$quote /F"
    $command_run1 = "schtasks.exe /RUN /TN 'Minion-Enable-WSRemoting1'"
    $command_run2 = "schtasks.exe /RUN /TN 'Minion-Enable-WSRemoting2'"
    $command_run3 = "schtasks.exe /RUN /TN 'Minion-Enable-WSRemoting3'"
    $command_delete1 = "schtasks.exe /DELETE /TN 'Minion-Enable-WSRemoting1' /F"
    $command_delete2 = "schtasks.exe /DELETE /TN 'Minion-Enable-WSRemoting2' /F"
    $command_delete3 = "schtasks.exe /DELETE /TN 'Minion-Enable-WSRemoting3' /F"

    $process = [WMICLASS]"\\$computername\ROOT\CIMV2:Win32_Process"
    $result1 = $process.Create($command_1)
    $result2 = $process.Create($command_run1)
    #   Write-Host "Enabling PSRemoting on:        " $computername
    Start-Sleep -s 5
    $result3 = $process.Create($command_delete1)
    Start-Sleep -s 1
    $result4 = $process.Create($command_2)
    $result5 = $process.Create($command_run2)
    #  Write-Host "Configuring WSMan on:          " $computername
    Start-Sleep -s 5
    $result6 = $process.Create($command_delete2)
    Start-Sleep -s 1
    $result7 = $process.Create($command_3)
    $result8 = $process.Create($command_run3)
    #   Write-Host "Configuring CredSSP Server on: " $computername
    Start-Sleep -s 5
    $result9 = $process.Create($command_delete3)
    Return
}

Workflow Remote-Fix {
    param($Inactive_List, $WinRM, $WinRMTest)

    Foreach -parallel ($comp in $Inactive_List) {
        IF ((Test-Connection $comp -Quiet -count 1 -buffersize 16) -eq "True") {
            Minion-Enable-PSRemoting-Server $comp
            $RemoteObj = New-Object -TypeName PSobject
            $WinRMTest = Get-Service -PScomputername $comp winrm
            If ($WinRMTest.Status -eq "Running") {
                $WinRM = "Active"
            }
            ELSE {
                $WINRM = "Inactive"
            }
            $RemoteObj = [PSCustomObject]@{
                Computername = $comp
                Remoting     = $WinRM
            }
            $RemoteObj
        }
    }
}
