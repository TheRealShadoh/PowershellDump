# I am just using this as an example script on scanning the network for a certain version of software or patch.
cd #Standard pause function
function Pause ($Message="Press any key to continue...")
{Write-Host -NoNewLine $Message
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""}
$instructions = @"
--Registry Key Finder Script--

WARNING!!!!!   WARNING!!!!!   WARNING!!!!!
dd
Do not click on any cells in the excel spreadsheet while it is still scanning.
It will mess up the exported data of the spreadsheet.
"@
$instructions

#This is where you place a list of computers in .txt format. You can also use a read-host command if you want a different list every time.
$targetpath = "C:\Users\timothy.brady\Desktop\Comps.txt"
$list = (get-content $targetpath)

#This is the important part
#You have to find the right key applicable to the patch or software you are scanning for. Most can be found by doing a find in regedit and within the installer
#or uninstaller folders of the registry. Reader X is listed below but MS patches can generally be found in the following folder of the registry:
#SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages
#Just search for the KB number.
$Key = ("\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\37954E682535F9341A51E2E84E4D1004\InstallProperties") #Active Client
$Key2 = ("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{26A24AE4-039D-4CA4-87B4-2F83216033FF}")
$KeySet = ("DisplayName")
$Version = ("DisplayVersion")
$State = ("CurrentState")

#Excel is opened up and formatted
$a = New-Object -comobject Excel.Application
$a.visible = $True 

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Computer Name:"
$c.Cells.Item(1,2) = "Ping Status:"
$c.Cells.Item(1,3) = "Java:"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True
$d.EntireColumn.AutoFilter()
$d.EntireColumn.AutoFit()

$intRow = 2

#This is where the scan will begin to run.
foreach ($strComputer in $list)
    {    
    $c.Cells.Item($intRow,1) = "$strComputer"
    # Ping with .NET.  I might change this after I review more stats and logs.
    $ping = new-object System.Net.NetworkInformation.Ping

    $Reply = $ping.send($strComputer)
                
                if($Reply.status -eq "success")
                {
                $c.Cells.Item($intRow,2).Interior.ColorIndex = 4
                $c.Cells.Item($intRow,2) = "Ping Success"
                                               
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("localmachine", $strComputer)
                #Make sure that you have the proper key variable below.
                $regKey = $reg.OpenSubKey("$Key2" )
                #This is where the information is actually located. For MS patches use the $State in place of the $Version variable.
                $val = $regkey.getvalue("$Version")
                    
                    #Place the value you wish to find below such as version number. 
                    if($val -eq "6.0.330")
                    {
                    $c.Cells.Item($intRow,3).Interior.ColorIndex = 4
                    $c.Cells.Item($intRow,3) = "Good"
                    }
                    Else
                    {
                    $c.Cells.Item($intRow,3).Interior.ColorIndex = 3
                    $c.Cells.Item($intRow,3) = "Bad"
                    }
                #Make sure that your script resets the $val back to null after each run as shown below.    
                $val = $null    
                }                                           
                Else
                {
                #If it failed the ping test
                $DataOutput = $MachineName + " Not Pingable"
                write-host $DataOutput
                $c.Cells.Item($intRow,2).Interior.ColorIndex = 3
                $c.Cells.Item($intRow,2) = "Not Pingable"
                }
                
    $intRow = $intRow + 1
    $regKey = ""
    $val = $null
    $Reply = $null
    }
     
$d.EntireColumn.AutoFit()

#Saves as RegQuery_Date-Time.xlsx in the current working directory
$date = Get-Date
$filename = "\RegQuery_{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f $date.year,$date.month,$date.day,$date.hour,$date.minute
$filename = $filename + ".xlsx"
$location = get-location
$filename = $location.path + $filename
Write-host "Saving file in:"
write-host $filename
$c.SaveAs("$filename") 