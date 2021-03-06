$Comp = Read-Host "Computer Name: "
$OS = Get-Wmiobject Win32_OperatingSystem -cn $Comp
$NIC = Get-WmiObject Win32_NetworkAdapterConfiguration -filter "IPEnabled='True'" -cn $Comp
$User = Get-WmiObject Win32_ComputerSystem -property username -cn $Comp
Write-Output "Comp: " $Comp | Out-File C:\Users\Test.txt
Write-Output "                      "  | Out-File C:\Users\Test.txt -append
Write-Output "IP:   " $NIC.IPAddress | Out-File C:\Users\Test.txt -append
Write-Output "                           "  | Out-File C:\Users\Test.txt -append
Write-Output "MAC:  " $NIC.MACAddress | Out-File C:\Users\Test.txt -append
Write-Output "                            "  | Out-File C:\Users\Test.txt -append
Write-Output "User: " $User.UserName | Out-File C:\Users\Test.txt -append
$Message = Get-Content "C:\Users\Test.txt"
Msg console /SERVER:$Comp $Message
Write-Host "User Messaged: $User" $User.UserName