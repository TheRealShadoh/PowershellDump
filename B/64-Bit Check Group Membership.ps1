$Computers = Get-Content \\Desktop\Comps.txt
ForEach ($Computer in $Computers)
{
    $Groups = (Get-ADPrincipalGroupMembership (Get-ADComputer $Computer).DistinguishedName).Name
    If ($Groups -like "GLS_xOSDx64")
    {
        Write-Host "$Computer is a member of GLS_xOSDx64"
    }
    If (!($Groups -like "GLS_xOSDx64"))
    {
        Write-Host "$Computer can be patched"
        "$Computer" | Out-File "\\Desktop\Add.txt" -Append -Force
    }
}