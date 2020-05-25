function Test-ADAuthentication
{
	param (
		$username,
		$password
	)
	(New-Object System.DirectoryServices.DirectoryEntry "", $username, $password).psbase.name -ne $null
}