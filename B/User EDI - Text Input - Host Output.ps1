﻿$Names = Get-Content "C:\Usmes.txt"
ForEach ($displayname in $Names)
{
    $domain = "OU=L"
    $objDomain = [adsi]("LDAP://" + $domain)
    $search = New-Object System.DirectoryServices.DirectorySearcher
    $search.SearchRoot = $objDomain
    $search.Filter = "(&(objectClass=user)(employeeType=*)(displayName=*$displayname*))"
    $search.SearchScope = "Subtree"
    $results = $search.FindAll()
    ForEach($item in $results)
    {
        $objUser = $item.GetDirectoryEntry()
        $Name = $objUser.displayname
        $Logon = $objUser.gigID
        Write-Host $Name $Logon
    }
}