$NetAdmin = "32.coml"
$DayLimit = 7
$Path = "C:\usic"
$Message = "The following server(s) have not been rebooted within $DayLimit days, please reboot them at your earliest convenience."
$Notice = "*This is an automatically generated email from PowerShell, if you have questions please reply directly to this email*"

Function SCOO
{
    $User = "SO"
    $UserMail = "3@.comil"
    $Computers = Get-Content "$Path\SO.txt"

    ForEach ($Computer in $Computers)
    {
        If (Test-Connection $Computer -Quiet -BufferSize 16 -Ea 0 -Count 1)
        {
            $LastBootTime = (Get-WmiObject Win32_OperatingSystem -cn $Computer -ErrorAction SilentlyContinue).LastBootUpTime
            $Uptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($LastBootTime)
            $Days = $Uptime.days
        }
        If ($Days -gt $DayLimit)
        {
            $Table += "$Computer   -   $Days days
"
        }
    }
    If ($Days -gt $DayLimit)
    {
        $Body = "$User,

$Message

$Table
$Notice

V/R

Net
D30"
        Send-MailMessage -From $NetAdmin -To $UserMail -Bcc $NetAdmin -Priority High -Subject "Server Uptime - $User" -Body $Body -SmtpServer
    
}