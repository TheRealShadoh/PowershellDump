function Send-FTP {
    $ESAIP = Read-Host "Enter the ESA IP"
	$openfiledialog1.ShowDialog()
	
	#Create the FTPWebRequest and Configure it
	$ftp = [System.Net.FtpWebRequest]::Create("ftp://$($ESAIP)/$($openfiledialog1.FileName)")
	$ftp = [system.Net.FtpWebRequest]$ftp
	$ftp.Method = [System.Net.WebRequestMethods+ftp]::UploadFile
	#$ftp.Credentials = New-Object System.Net.NetworkCredential("admin", "")
	$ftp.UseBinary = $true
	$ftp.UsePassive = $true
	#Read in the file to upload as byte array
	$content = [System.IO.File]::ReadAllBytes("$($openfiledialog1.FileName)")
	$ftp.ContentLength = $content.Length
	# Get the request stream, and write the bytes into it
	$rs = $ftp.GetRequestStream()
	$rs.Write($content, 0, $content.Length)
	# clean up
	$rs.close()
	$rs.Dispose()
}