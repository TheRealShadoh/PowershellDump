$NetPath = "\\Xation\Patches"
$file1 = "32BITPatches.bat"
$file2 = "64BITPatches.bat"
Copy-Item "$NetPath\$file1" -Destination \\$Computer\C$
Copy-Item "$NetPath\$file2" -Destination \\$Computer\C$