$domain = "OU=  ,OU= ,OU=,OU=,DC=,DC=,DC=,DC=" 
$Orgs = Get-ADOrganizationalUnit -LDAPFilter '(name=*)' -SearchBase "$domain" -SearchScope Subtree | Format-Table Name