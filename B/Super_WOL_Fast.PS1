#################################Start Instruction Block########################################################
#pause function after the intructions are displayed
function Pause ($Message="Press any key to continue...")
{
Write-Host -NoNewLine $Message
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""
}

cls
######################################################
##############IE WOLory Recovery Script##############

$instructions = @"



**********Super WaKe On LaN**********

This script will trigger a Wake On Lan event across the domain. 

Requirements:  
1. psexec installed somewhere
2. List of all host MAC addresses
3. Make sure to run this as admin!

Setup: Create a txt file of all of your MAC addresses (can be exported from SCCM)
and put them in this format:

"00-11-22-33-44-55",
"00-11-22-33-44-55",
"00-11-22-33-44-55",
"00-11-22-33-44-55",
"00-11-22-33-44-55"    <--ensure the last MAC does not have the trailing comma ","

If you do not want the verbose mode, uncomment the end of the line that starts with start-job.
This will include the "| out-null" and it won't print all of the red/yellow on the screen.



-Written by Ha

"@
$instructions

Pause

#################################End Instruction Block########################################################

$starttimer = Get-Date

Write-host ""
Write-host ""
$macPath = read-host "Specify your MAC address txt file.  ie: c:\scripts\macs.txt"
$psexecpath = read-host "Enter the folder path to psexec.  ie: c:\pstools"
$MaxConcurrentJobs = read-host "Enter the max number of threads you would like to run.  I use 50"
$username = read-host "Enter your remote access username (to be used with psexec).  ie: jon.smith.adm"
$password = read-host "Enter your password (to be used with psexec)."
#$cred = Get-Credential "osan\tavis.ha.adm"

#SSgt Ha is your daddy. 2 Nov 2011


set-alias psexec "$psexecpath\psexec.exe"

$path = (get-location).path
$wolpath = "$path\wol_testbuild3.ps1"
$batpath = "$path\wol.bat"
$Scriptpath = "$path\scriptBlock.ps1"
$wspath = "$path\workstations.txt"  
$counter = 1      

Write-host ""
Write-host ""
Write-host "Creating wol_testbuild3.ps1"
Write-host ""
Write-host ""


################Script Build Block################################

Clear-content $wolpath
Clear-content $batpath
Clear-content $Scriptpath

$woladd = "`$macs = @("
add-content $wolpath -value $woladd

$woladd = get-content $macPath

add-content $wolpath -value $woladd



$woladd = @"

)

`$counter = 1

foreach (`$input in `$macs)
{

write-host `$counter
 
 
`$mac = [byte[]](`$input.split('-') |% {[int]"0x`$_"}) 
 
`$UDPclient = new-Object System.Net.Sockets.UdpClient
`$UDPclient.Connect(([System.Net.IPAddress]::Broadcast),4000)
`$packet = [byte[]](,0xFF * 102)
6..101 |% { `$packet[`$_] = `$mac[(`$_%6)]}
`$UDPclient.Send(`$packet, `$packet.Length)
`$UDPclient.Send(`$packet, `$packet.Length)
`$UDPclient.Send(`$packet, `$packet.Length)
`$UDPclient.Send(`$packet, `$packet.Length)
`$UDPclient.Send(`$packet, `$packet.Length)
`$UDPclient.Send(`$packet, `$packet.Length)

`$counter = `$counter + 1
}



exit
#SSgt Ha is your daddy. 2 Nov 2011
"@

add-content $wolpath -value $woladd

$bat = @"

powershell -executionpolicy unrestricted -file c:\wol_testbuild3.ps1

exit

"@

add-content $batpath -value $bat


$scriptBlock = @" 
Param(`$MachineName,`$wolpath,`$path,`$username,`$password,`$batpath,`$psexecpath)
    
    set-alias psexec "`$psexecpath\psexec.exe" 
    #SSgt Ha is your daddy. 2 Nov 2011	
    # Ping with .NET.  I might change this after I review more stats and logs.
    #`$ping = new-object System.Net.NetworkInformation.Ping

    #`$Reply = `$ping.send("`$MachineName")
      `$Reply = test-connection `$MachineName -quiet

                #if(`$Reply.status -eq "success")
                if(`$Reply -eq `$true)
                {

               
                copy-item `$wolpath "\\`$MachineName\C`$" -verbose
                
                        add-content `$path\wol_Log.txt -value `$MachineName
                      & PsExec \\`$MachineName -h -c -f -d -u osan\`$username -p `$password `$batpath


                
                }

"@


add-content $Scriptpath -value $scriptBlock

write-host "sleeping 5 seconds"
start-sleep -seconds 5


################End Script Build################################


#SSgt Ha is your daddy. 2 Nov 2011


Write-host ""
Write-host ""
clear-content $wspath      
      
      
      #Directory search polls AD for systems
      Write-host "Polling Active Directory for Win 7 Computers"
      Write-host ""
      Write-host ""
      $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
      $root = $domain.GetDirectoryEntry()
      $search = [System.DirectoryServices.DirectorySearcher]$root
      $Search.PageSize = 1000
      $Search.SearchScope = "Subtree"
      
      $search.filter = "(&(objectClass=computer)(OperatingSystem=Windows*7*))"
      $Search.SearchScope = "Subtree"
      $result = $search.findall()

      
      
      #$search.filter = "(&(objectClass=computer)(name=os018a6f2vkh1))"
      #$Search.SearchScope = "Subtree"
      #$result = $search.findone()



foreach ($strComputer in $result)
    
    {
    $PCName = $strComputer.Properties["name"]
     $CollSystems += $PCName
    }
    
   
    
   $CollSystems | foreach {
            if ($_.length -gt 0)
    		{
            "Querying $testcounter {0}" -f $_ 
            $testcounter ++
            
            $machineName = $_
            "Querying $testcounter {0}" -f $machineName
            
            $args = "$MachineName $wolpath $path $username $password $batpath $psexecpath"
           
            $args
           
            
           start-job -FilePath $Scriptpath -ArgumentList $MachineName,$wolpath,$path,$username,$password,$batpath,$psexecpath -name("WOL-" + $_) #| out-null
           
            get-job | where { $_.Name -like "WOL*" -and $_.state -eq "Completed" } | % { $WOLResults += Receive-Job $_ ; Remove-Job $_ }
            
            }    		
		
            while (((get-job | where-object { $_.Name -like "WOL*" -and $_.State -eq "Running" }) | measure).Count -gt $MaxConcurrentJobs)
		    {
            "{0} Concurrent jobs running, sleeping 5 seconds" -f $MaxConcurrentJobs
            get-job | where { $_.Name -like "WOL*" -and $_.state -eq "Completed" } | % { Receive-Job $_ ; Remove-Job $_ }
			Start-Sleep -seconds 5
		    }
	    }
    
            while (((get-job | where-object { $_.Name -like "WOL*" -and $_.State -eq "Running" }) | measure).Count -gt 0)
		    {
            "{0} Concurrent jobs running, sleeping 5 seconds" -f $MaxConcurrentJobs
            get-job | where { $_.Name -like "WOL*" -and $_.state -eq "Completed" } | % { Receive-Job $_ ; Remove-Job $_ }
			Start-Sleep -seconds 5
		    } 
   write-host "Starting sleep 60 seconds while remaining threads finish."         
   start-sleep -seconds 60         
   get-job | where { $_.Name -like "WOL*" -and $_.state -eq "Completed" } | % { Receive-Job $_ ; Remove-Job $_ } 
   get-job | where { $_.Name -like "WOL*" -and $_.state -eq "Failed" } | % { Receive-Job $_ ; Remove-Job $_ }              

   write-host ""
   write-host ""
   write-host "" 
   $stoptimer = Get-Date
   "Total time for actions: {0} Minutes" -f [math]::round(($stoptimer - $starttimer).TotalMinutes , 2)



#Det 1 stinks! Long Live NCC 

