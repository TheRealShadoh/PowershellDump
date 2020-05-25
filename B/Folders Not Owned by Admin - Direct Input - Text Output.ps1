$OPath = "C:\Usults.txt"
$RootFolder = Get-ChildItem -Recurse -Path "\\S"
ForEach ($Folder in $RootFolder)
{
$Access = Get-ACL $Folder.FullName 
    If($Access.Owner -ne "BUILTIN\Administrators")
    {
    Write-OutPut "File Name: " $Folder.FullName "Owner: " $Access.Owner |
    Out-File $OPath -append
    } 
 }