$Comp = (Get-Content C:\ps.txt)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -filter "IPEnabled='True'" -cn $Comp | Select IPAddress, MACAddress