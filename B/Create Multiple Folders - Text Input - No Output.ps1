$Servers = Get-Content C:\Users\Server.txt
ForEach ($Name in $Servers)
{
    New-Item -ItemType Directory -Path "\\XLW\Results\$Name"
}