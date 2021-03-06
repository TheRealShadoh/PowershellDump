$spath = "\\52dy\Desktop"
$opath = "C:\Users\timody\Desktop\Results.txt"
#-----------------------------------------------------------
$SSN_Regex = "[0-9]{3}[-| ][0-9]{2}[-| ][0-9]{4}"
$PN_Regex = "[0-9]{3}[-| ][0-9]{3}[-| ][0-9]{4}"
#-----------------------------------------------------------
Get-ChildItem $spath -Exclude *.dll, *.exe -Recurse | Select-String -Pattern $SSN_Regex | Select-Object Path,Filename,Matches | Format-List -Force | Out-File $opath
Get-ChildItem $spath -Exclude *.dll, *.exe -Recurse | Select-String -Pattern $PN_Regex | Select-Object Path,Filename,Matches | Format-List -Force | Out-File $opath -Append