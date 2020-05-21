$domain = "OU=  ,OU= ,OU=,OU=,DC=,DC=,DC=,DC=" 
$objDomain = [adsi]("LDAP://" + $domain) 
$search = New-Object System.DirectoryServices.DirectorySearcher 
$search.SearchRoot = $objDomain 
$search.Filter = "(&(ObjectCategory=computer))" 
$search.SearchScope = "Subtree" 
$results = $search.FindAll()
$listing =@()

foreach($item in $results) 
{ 
    $objComputer = $item.GetDirectoryEntry() 
    $Name = $objComputer.cn 
    $listing += $name
} 
