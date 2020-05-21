
function Get-ADComputer-LDAP
{
	param (
		
	)
	
	$CurrentDomain = $env:USERDNSDOMAIN
	
	IF ($CurrentDomain.Split(".").count -eq 4)
	{
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3])")
	}
	IF ($CurrentDomain.Split(".").count -eq 5)
	{
		$root = ([adsi]"LDAP://DC=$($($CurrentDomain).split(".")[0]),DC=$($($CurrentDomain).split(".")[1]),DC=$($($CurrentDomain).split(".")[2]),DC=$($($CurrentDomain).split(".")[3]),DC=$($($CurrentDomain).split(".")[4])")
	}
	
	$searcher = New-Object System.DirectoryServices.DirectorySearcher($root)
	$searcher.Filter = "(objectCategory=computer)"
	$searcher.PageSize = 1000
	$searcher.PropertiesToLoad.Add("name")
	$comps = $searcher.FindAll()
	$comps.Properties.name
}

