﻿
import-module ActiveDirectory
$ErrorActionPreference = "SilentlyContinue"

$users =get-aduser -Filter {ObjectClass -eq "User"} -searchbase "OU= , OU=,OU=,DC=,dc=,dc=,dc=" -Properties personalTitle, DisplayName, CN, o, Office, ExtensionAttribute5,mDBStorageQuota,mDBOverHardQuotaLimit | where {$_.personalTitle -eq ""}
   
   $array = @()
Foreach ($user in $users) {   
$obj = [PSCustomObject] @{
            Name = $user.cn
            Office= $user.Office
            MailboxCAT = $user.ExtensionAttribute5
            SoftLimit = ($user.mDBStorageQuota /1014)
            HardLimit = ($user.mDBOverHardQuotaLimit/1024) 
            }
$array += $obj
            }        

"Check your C: for the file MailboxSizes.csv to see the results"


$array | Export-csv C:\MailboxSizes.csv

         
         
         
         
         
         