$Computers = Get-Content "C:\Users\timdy\Desktop\Comps.txt"
ForEach ($Comp in $Computers){
Get-WmiObject Win32_Printer -cn $Comp -ErrorAction SilentlyContinue |
Where-Object {($_.Name -notlike "*Adobe*") -and
              ($_.Name -notlike "*OneNote*") -and 
              ($_.Name -notlike "*Microsoft*") -and 
              ($_.Name -notlike "Fax")} |
              Select Name, SystemName}