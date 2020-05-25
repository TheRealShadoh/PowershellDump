
function Get-ADComputer-LDAP {
	$CurrentDomain = $env:USERDNSDOMAIN

	IF ($CurrentDomain.Split(".").count -eq 4) {
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3])")
	}
	IF ($CurrentDomain.Split(".").count -eq 5) {
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3]),DC=$($($CurrentDomain).split(".")[4])")
	}

	$searcher = New-Object System.DirectoryServices.DirectorySearcher($root)
	$searcher.Filter = "(objectCategory=computer)"
	$searcher.PageSize = 1000
	$searcher.PropertiesToLoad.Add("name")
	$comps = $searcher.FindAll()
	$comps.Properties.name
}

Function Sudo-Get-ADComputer {
		<#
	.SYNOPSIS
		Created: TheRealShadoh
	.DESCRIPTION
		I don't recall this one, but it looks like it's supposed to replce the Get-ADComputer-LDAP
		Use LDAP to get computers in AD, you don't need the ActiveDirectory module installed. This is setup to only work if the FQDN is 4 or 5 level deep.
#>
    Param ($DC)
    $GetCred = Get-Credential

    $strFilter = "(&(objectCategory=Computer))"

    $objDomain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC", $($GetCred.Username), $($GetCred.GetNetworkCredential().password))

    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher("LDAP://$DC")
    $objSearcher.SearchRoot = $objDomain
    $objSearcher.PageSize = 1000
    $objSearcher.Filter = $strFilter
    $objSearcher.SearchScope = "Subtree"

    $colProplist = "name"
    foreach ($i in $colPropList) {
        $objSearcher.PropertiesToLoad.Add($i)
    }

    $colResults = $objSearcher.FindAll()
    $array = @()
    Foreach ($result in $colResults) {
        $result = $result.path.ToString().split()[0].split(",")[0].split("=")[1]
        $array += $result
    }
    $array
}
