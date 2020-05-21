Function Sudo-Get-ADComputer {
    Param ($DC)
        $GetCred = Get-Credential 
        
        $strFilter = "(&(objectCategory=Computer))"

        $objDomain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC",$($GetCred.Username),$($GetCred.GetNetworkCredential().password))

        $objSearcher = New-Object System.DirectoryServices.DirectorySearcher("LDAP://$DC")
        $objSearcher.SearchRoot = $objDomain
        $objSearcher.PageSize = 1000
        $objSearcher.Filter = $strFilter
        $objSearcher.SearchScope = "Subtree"

        $colProplist = "name"
        foreach ($i in $colPropList){
            $objSearcher.PropertiesToLoad.Add($i)
        }

        $colResults = $objSearcher.FindAll()
        $array = @()
        Foreach ($result in $colResults){
            $result = $result.path.ToString().split()[0].split(",")[0].split("=")[1]
            $array += $result
        }
        $array
}
