$objADSI = [adsi]""
$domain = $objADSI.distinguishedname
$objDomain = [adsi]("LDAP://" + $domain)
$search = New-Object System.DirectoryServices.DirectorySearcher
$search.SearchRoot = $objDomain
$search.Filter = "(&(objectClass=user)(employeeType=*)(displayName=*Singleton, Scott*))"
$search.SearchScope = "Subtree"
$results = $search.FindAll()
foreach($item in $results)
{
    $objUser = $item.GetDirectoryEntry()
    $Time = $objUser.LastLogonTimestamp
    $Date = Get-Date -Date ([DateTime]::FromFileTime($objUser.ConvertLargeIntegerToInt64($objUser.lastlogontimestamp[0])))
    $Name = $objUser.displayname
    $LastLogon = ($Date.Date | Select Date)
    $Today=(Get-Date).AddDays(-10)
If ($Date -lt $Today){    
    Write-Output "Display Name" | Format-Table | Out-File C:\Users\timothy.brady\Desktop\Users.txt -append
    Write-Output "------- ----" $Name, $LastLogon | Format-Table | Out-File C:\Users\timothy.brady\Desktop\Users.txt -append}
Else {Write-Host "$Name has logged in recently: $LastLogon"}
}