$Orgs = Get-Content -Path "C:\Uss.txt"
ForEach ($Org in $Orgs)
{
    $Match = Select-String -Path "C:\Ussktop\Orgs.txt" -Pattern $Org -AllMatches | Select -ExpandProperty Matches
    $Match
}