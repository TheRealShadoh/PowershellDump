$Exclusions = "JR's", "Napoli's", "Chick fil a"

$Places = "McDonald's", "Wendy's", "Hibachi", "DQ", "Gary's", "Napoli's", "Old Mexico", "Jimmy Johns", "Firehouse", "Chick fil a", "Thai", "BX", "Third Party", "JR's", "Bowling"

$Lunch = Get-Random -Count 1 $Places
ForEach ($Exclusion in $Exclusions)
{
    If ($Lunch -like $Exclusion)
    {
        Write-Host $Lunch
        $Lunch = Get-Random -Count 1 $Places
    }
}

$c = New-Object -Comobject wscript.shell
$b = $c.popup("$Lunch",0,"Lunch",0)

$Body = "Lunchinator 5000 says:

$Lunch"

Send-MailMessage -From "tl" -To "lol",  -Priority High -Subject "Lunch" -Body $Body -SmtpServer wrl