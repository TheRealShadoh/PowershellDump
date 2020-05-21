$Directory = "\\XStats\User_Stats"
$Names = Get-Content "C:\ktop\Names.txt"
ForEach ($Name in $Names)
{
    $Files = Get-ChildItem -Recurse -Force $Directory -ErrorAction SilentlyContinue | Where-Object {($_.PSIsContainer -eq $false) -and  ($_.Name -like "*$Name*")}
    $Files | Copy-Item -Destination "C:\ktop\Test"
}