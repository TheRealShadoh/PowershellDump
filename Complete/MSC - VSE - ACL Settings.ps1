$Path = "\\share"
Write-Host "Enter the full username, "
$Username = Read-Host "Enter Full Username"

$Directories = Get-ChildItem $Path | Where { $_.PSIsContainer } |Select FullName
Foreach ($Directory in $Directories.FullName) {
    "Setting permission on $($Directory)"
    $ACL = Get-Acl $Directory
    $AR = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'Modify', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
    $ACL.SetAccessRule($AR)
    Set-Acl $Directory $ACL

}

Read-Host "Press ENTER"