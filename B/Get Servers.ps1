﻿$domain = "OU"
$objDomain = [adsi]("LDAP://" + $domain)
$search = New-Object System.DirectoryServices.DirectorySearcher
$search.SearchRoot = $objDomain
$search.Filter = "(&(objectClass=computer)(name=*))"
$search.SearchScope = "Subtree"
$search.PageSize = 99999
$results = $search.FindAll()
ForEach($item in $results)
{
    $objComputer = $item.GetDirectoryEntry()
    If ($objComputer.distinguishedName -like "*T*")
    {
        $Name = $objComputer.name
        Write-Host $Name
    }
}
Write-Host $Name.Count