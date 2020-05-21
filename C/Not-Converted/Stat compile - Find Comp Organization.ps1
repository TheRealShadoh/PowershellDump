            $directory = "\\x\Computer_stats\Windows\*.*"
            $csvFiles = get-childitem $directory -filter *.csv

            $results = @();


            Foreach ($csv in $csvFiles) {
                $results += import-csv $csv
                $i++
                Write-Host "." -ForegroundColor Cyan
                Write-Progress -activity “Combining Information” -status “Status: $i/$($csvfiles.count)” -PercentComplete (($i / $csvFiles.count)*100)
                 }

            $i = $null

$compList = get-content "C:\9.14.txt"


$match = $results.computername | ?{$complist -contains $_}

$ObjPrint = @()
Foreach ($str in $match) {
    $Cycleobj = [PSCustomObject] @{
    Name = $results | where {$_.computername -eq "$str"} | select -expandproperty Computername
    IP =  $results | where {$_.computername -eq "$str"} | select -expandproperty IPAddress
    Location =  $results | where {$_.computername -eq "$str"} | select -expandproperty Location
    }

    $objPrint += $Cycleobj
   
    }

