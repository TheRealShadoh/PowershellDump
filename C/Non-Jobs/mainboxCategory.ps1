$ErrorActionPreference = "SilentlyContinue"

$users =get-aduser -Filter {ObjectClass -eq "User"} -searchbase "OU= , OU=,OU=,DC=,dc=,dc=,dc="  -Properties DisplayName, CN, o, Office, ExtensionAttribute5| ? {$_.office -like "CC"} |select -Property *
   
   $array = @()
Foreach ($user in $users) {   
$obj = [PSCustomObject] @{
            Name = $user | select -expandproperty DisplayName 
            Organization = $user.o[0]
            Office= $user.Office
            MailboxCAT = $user.ExtensionAttribute5
            }
$array += $obj
            }        

$array | where {$_.mailboxCAT -ne "1"} |Format-Table -AutoSize
$array | where {$_.mailboxCAT -ne "1"} |Format-Table -AutoSize | Export-csv C:\MailboxCAT.csv
