$IPs = Get-Content C:\Users\\Desktop\IPAddresses.txt

ForEach ($IP in $IPs)
{
    Try { $Name = [System.Net.DNS]::GetHostByAddress($IP).HostName.Split(".")[0] }
    Catch { $Name = "No record" }
    Write-Host "$IP : $Name"
}