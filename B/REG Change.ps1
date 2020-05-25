$Computers = Get-Content C:\Users\trady\Desktop\Comps.txt
ForEach ($Computer in $Computers)
{
    REG ADD "\\$Computer\HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t REG_DWORD /d 1 /f
}