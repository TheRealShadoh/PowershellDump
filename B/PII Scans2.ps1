
param (
	[parameter(Mandatory=$True)]
	[ValidatePattern("\\52ady\Desktop")]
	[string]$SourcePath
)

# -----------------------------------------------------------------------------
# Variable initialization and setup
# -----------------------------------------------------------------------------
$MasterDirectory	= "\\52Xady\Desktop"
if (-not (Test-Path -PathType Container $SourcePath)) {
	Write-Error -Message "Error: Path does not exist." -Category ObjectNotFound -TargetObject $SourcePath
	exit
}
$Server				= $SourcePath.Split("\")[2]
$Unit				= $SourcePath.Split("\")[-1]
$WorkingDirectory	= $MasterDirectory + "\" + $Server
if (-not (Test-Path -PathType Container $WorkingDirectory)) {
	New-Item -Type Directory -Path $WorkingDirectory
}
$XfdlLog			= $WorkingDirectory + "\" + $Unit + "_xfdl_docs.txt"
$WordLog			= $WorkingDirectory + "\" + $Unit + "_word_docs.txt"
$XfdlLogStream		= [System.IO.StreamWriter] $XfdlLog
$WordLogStream		= [System.IO.StreamWriter] $WordLog

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
Function TestFileLock {
    # Attempts to open a file and trap the resulting error if the file is already open/locked
    param ([string]$FilePath )
    $FileLocked = $False
    $FileInfo	= New-Object System.IO.FileInfo $FilePath
    trap {
		Set-Variable -name FileLocked -value $True -scope 1 
        continue
    }
    $FileStream = $FileInfo.Open( [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None )
    if ($FileStream) {
        $FileStream.Close()
    }
    $obj = New-Object Object
    $obj | Add-Member Noteproperty FilePath -value $FilePath
    $obj | Add-Member Noteproperty IsLocked -value $Filelocked
	return $obj
}

# -----------------------------------------------------------------------------
# Find all XFDL and Word documents
# -----------------------------------------------------------------------------
$all_docs	= Get-ChildItem $SourcePath -include "*.xfdl","*.doc","*.docx" -recurse
$xfdl_docs	= @()
$word_docs	= @()
ForEach ($doc in $all_docs) {
	if ($doc.Extension -eq ".xfdl") {
		$xfdl_docs += $doc.FullName
	} else {
		$word_docs += $doc.FullName
	}
}

# -----------------------------------------------------------------------------
# XFDL file operations
# -----------------------------------------------------------------------------
$XfdlLogStream.WriteLine("-----------------------------------------------------")
$XfdlLogStream.WriteLine("XFDL Documents")
$XfdlLogStream.WriteLine("-----------------------------------------------------")
$XfdlLogStream.WriteLine()
$XfdlSearchStrings = @("[EO]PR","707","910","911","55","4392")
$XfdlCount 	= 0
ForEach ($Xfdl in $xfdl_docs) {
    $epr	= $Xfdl -match $XfdlSearchStrings[0]
    $f707	= $Xfdl -match $XfdlSearchStrings[1]
    $f910	= $Xfdl -match $XfdlSearchStrings[2]
	$f911	= $Xfdl -match $XfdlSearchStrings[3]
	$f55	= $Xfdl -match $XfdlSearchStrings[4]
    $f4392  = $xfdl -match $XfdlSearchStrings[5]
    if (($epr) -or ($f707) -or ($f910) -or ($f911) -or ($f55) -or ($f4392)) {
	   $XfdlLogStream.WriteLine($Xfdl)
	   $XfdlCount += 1
    }
}
$XfdlLogStream.Close()

# -----------------------------------------------------------------------------
# Word document operations
# -----------------------------------------------------------------------------
# Regex patterns
$FindSocial	= "\b\d{3}-?\d{2}-?\d{4}"
$FindPhone	= "\b(\(?\d{3}\)?[-. ]?)?\d{3}[-.]?\d{4}"

# Open and configure MS Word
$Word = New-Object -ComObject "Word.Application"
$Word.Visible = $False
$Word.WordBasic.DisableAutoMacros
$Word.AutomationSecurity = "msoAutomationSecurityForceDisable"
$Missing = [System.Reflection.Missing]::Value

# Open each Word doc, save it as a text file and perform regex searches on the text file
$WordLogStream.WriteLine("---------------------------------------------------------")
$WordLogStream.WriteLine("Word Documents With Possible Hits")
$WordLogStream.WriteLine("---------------------------------------------------------")
$WordLogStream.WriteLine()
$WordDocCount = 0
ForEach ($Wdoc in $word_docs) {
	if (-not (TestFileLock($Wdoc)).IsLocked) {
		Write-Host -ForegroundColor Blue Opening $Wdoc "--" (Get-Date).ToLongTimeString() ...
		$OpenDoc = $Word.Documents.Open($Wdoc, $Missing, $True, $Missing, "", $Missing, $Missing, $Missing, $Missing, $Missing, $Missing, $Missing, $Missing, $Missing, $False)
		if ($? -eq $True) {
			$Text = $OpenDoc.Content.Text
			
			$OpenDoc.Close()
			
			$FoundSocial	= $Text -match $FindSocial
			$FoundPhone		= $Text -match $FindPhone
			
			if ($FoundSocial -or $FoundPhone) {
				$WordLogStream.WriteLine($Wdoc)
				$WordLogStream.Flush()
				$WordDocCount += 1
			}
		}
	}
	$Word.Visible = $False
}
$Word.Quit()
$WordLogStream.Close()

# -----------------------------------------------------------------------------
# Final operations
# -----------------------------------------------------------------------------
Write-Host Found $XfdlCount XFDL Documents
Write-Host Found $WordDocCount MS Word Documents