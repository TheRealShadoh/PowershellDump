﻿$BLDG = Read-Host "Building Number"
$domain = "OU= ,OU=,OU=,DC=,DC=,DC=,DC="
$objDomain = [adsi]("LDAP://" + $domain)
$search = New-Object System.DirectoryServices.DirectorySearcher
$search.SearchRoot = $objDomain
$search.Filter = "(&(objectClass=computer)(location=*BLDG: $BLDG*))"
$search.SearchScope = "Subtree"
$results = $search.FindAll()
ForEach($item in $results)
{
    $objComputer = $item.GetDirectoryEntry()
    $Name = $objComputer.cn
    Write-Host "$Name"
}