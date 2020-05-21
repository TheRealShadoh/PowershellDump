$Computers = Get-Content \\xlwu-fs-004\Home\1392134782A\Desktop\Java.txt
ForEach ($Computer in $Computers)
{
    $Groups = (Get-ADPrincipalGroupMembership (Get-ADComputer $Computer).DistinguishedName).Name
    If ($Groups -like "Java Push Exemption*")
    {
        Write-Host "$Computer is a member of Java Exemption Group"
    }
    If (!($Groups -like "Java Push Exemption*"))
    {
        Write-Host "$Computer can be patched"
        "$Computer" | Out-File "\\x\Desktop\JavaPatch.txt" -Append -Force
    }
}