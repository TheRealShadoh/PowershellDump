$a = "<style>"
$a = $a + "BODY{background-color:palegoldenrod;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color:grey}"
$a = $a + "TD{border-width: 1px;padding: 1px;border-style: solid;border-color: black;background-color:white}"
$a = $a + "</style>"
Get-ChildItem -Force "\\XLg_all" -ErrorAction SilentlyContinue |
Select Name,POC | ConvertTo-HTML -body $a |
Out-File "C:\Users\ti\Desktop\Mders.html"