$Directory = "\\xBLIC"

$Files = Get-ChildItem $Directory -Recurse | Where {$_.Mode -notlike "*d*"}
ForEach ($File in $Files)
{
    $Docs = $File.DirectoryName + "\" + $File.Name
    $Dups = Get-ItemProperty -Path $Docs | Where {$_.Attributes -like "*Compressed"}
    $Dups
}