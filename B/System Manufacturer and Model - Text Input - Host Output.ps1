#$Computers = Get-Content "C:\Users\Timesktop\Server.txt"
#ForEach($PC in $Computers)
#{
 $PC = "521P"
    If (Test-Connection $PC -quiet -count 1)
    {
    $Model = Get-WmiObject Win32_Computersystem -cn $PC
    Write-Host
    Write-Host "Name         :" $PC
    Write-Host "Manufacturer :" $Model.Manufacturer
    Write-Host "Model        :" $Model.Model
    Write-Host
    }
    Else {Write-Host "$PC not reachable"}
#}