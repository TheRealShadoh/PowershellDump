$spath = "C:\Users\timady\Desktop"
$opath = "C:\Users\timdy\Documents\Results.csv"
#-----------------------------------------------------------
$SSN_Regex = "[0-9]{3}[-| ][0-9]{2}[-| ][0-9]{4}"
$PN_Regex = "[0-9]{3}[-| ][0-9]{3}[-| ][0-9]{4}"
#-----------------------------------------------------------
Get-ChildItem -Path $spath -Recurse | Select-String -Pattern $SSN_Regex | Select-Object Path,Filename,Matches | Export-CSV $opath
Get-ChildItem -Path $spath -Recurse | Select-String -Pattern $PN_Regex | Select-Object Path,Filename,Matches | Export-CSV $opath