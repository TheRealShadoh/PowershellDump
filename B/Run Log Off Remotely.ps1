$Server = "TYNT0603"
$Process = [WMICLASS]"\\$TY603\ROOT\CIMV2:win32_process"
$Result = $Process.Create("C:\Brff\Batch Files\Message With IF.bat")