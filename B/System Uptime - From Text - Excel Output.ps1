$erroractionpreference = "SilentlyContinue"

$NetAdmin = "3@gmail.com"

$Path = "C:\Us"
Remove-Item -Path $path -Force -ErrorAction SilentlyContinue

$a = New-Object -comobject Excel.Application
$a.visible = $True

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Machine Name"
$c.Cells.Item(1,2) = "IP Address"
$c.Cells.Item(1,3) = "Days Since Last Reboot"
$c.Cells.Item(1,6) = "Systems Offline"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True

$e = $c.Cells.Item(1,7)

$intRow = 2

$colComputers = get-content "C:\Users\sktop\Servers.txt"

ForEach ($strComputer in $colComputers)
{
    If (Test-Connection $strComputer -quiet -BufferSize 16 -Ea 0 -count 1)
    {
        $c.Cells.Item($intRow,1) = $strComputer
                          
            Function GetIPInfo
            {
                $resolveIP = [System.Net.Dns]::GetHostAddresses("$strComputer")
                $ipInfo = $resolveIP.IPAddressToString
             
                $c.Cells.Item($intRow,2) = $ipInfo              
            }        
            GetIPInfo
            
            Function GetLastBoot 
            {
                $lastboottime = (Get-WmiObject Win32_OperatingSystem -cn $strComputer -ErrorAction SilentlyContinue).LastBootUpTime
                $sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
                $bootresults = $sysuptime.days
                
                $c.Cells.Item($intRow,3) = $bootresults
            }
            GetLastBoot
    }    
    Else {$c.Cells.Item($intRow,6) = "$strComputer Not Reachable"} 
    
    $intRow = $intRow + 1
}
$d.EntireColumn.AutoFit()

$b.SaveAs($Path)
$b.Close()

$a.Quit()

$Body = "Attached

v/r

"

#Send-MailMessage -From "3@gmail.com" -To "mich@l.com" -Priority High -Attachments $Path -Subject "Server Uptimes" -Body $Body -SmtpServer wrl

$Popup = New-Object -Comobject wscript.shell
$RunPopup = $Popup.popup("The script has completed",0,"Complete",80)