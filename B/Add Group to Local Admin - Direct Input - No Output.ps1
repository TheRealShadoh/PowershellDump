$Computer = "3614LR"
$objUser = [ADSI]("WinNT://x/x")
$objGroup = [ADSI]("WinNT://$Computer/Administrators")
$objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)