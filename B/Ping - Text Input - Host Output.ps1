$Computers = Get-Content "C:\Users\tidy\Desktop\Comps.txt"
ForEach($Computer in $Computers){Ping -n 1 $Computer}