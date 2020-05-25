$STIGExamine_Load={
	#TODO: Initialize Form Controls here
	
}


#region Control Helper Functions
function Update-ListBox
{
<#
	.SYNOPSIS
		This functions helps you load items into a ListBox or CheckedListBox.
	
	.DESCRIPTION
		Use this function to dynamically load items into the ListBox control.
	
	.PARAMETER ListBox
		The ListBox control you want to add items to.
	
	.PARAMETER Items
		The object or objects you wish to load into the ListBox's Items collection.
	
	.PARAMETER DisplayMember
		Indicates the property to display for the items in this control.
	
	.PARAMETER Append
		Adds the item(s) to the ListBox without clearing the Items collection.
	
	.EXAMPLE
		Update-ListBox $ListBox1 "Red", "White", "Blue"
	
	.EXAMPLE
		Update-ListBox $listBox1 "Red" -Append
		Update-ListBox $listBox1 "White" -Append
		Update-ListBox $listBox1 "Blue" -Append
	
	.EXAMPLE
		Update-ListBox $listBox1 (Get-Process) "ProcessName"
	
	.NOTES
		Additional information about the function.
#>
	
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNull()]
		[System.Windows.Forms.ListBox]
		$ListBox,
		[Parameter(Mandatory = $true)]
		[ValidateNotNull()]
		$Items,
		[Parameter(Mandatory = $false)]
		[string]
		$DisplayMember,
		[switch]
		$Append
	)
	
	if (-not $Append)
	{
		$listBox.Items.Clear()
	}
	
	if ($Items -is [System.Windows.Forms.ListBox+ObjectCollection])
	{
		$listBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array])
	{
		$listBox.BeginUpdate()
		foreach ($obj in $Items)
		{
			$listBox.Items.Add($obj)
		}
		$listBox.EndUpdate()
	}
	else
	{
		$listBox.Items.Add($Items)
	}
	
	$listBox.DisplayMember = $DisplayMember
}
#endregion

$buttonProcess_Click = {
	$SelectedChecklists = $checkedlistbox1.CheckedItems
	$WorkingChecklistsArray = @()
	foreach ($obj in $SelectedChecklists)
	{
		IF ($script:AvailableChecklists -match $obj)
		{
			$WorkingChecklistsArray += ($script:AvailableChecklists -match $obj)
		}
		
	}
	$SelectedChecklists = $WorkingChecklistsArray
	$progressbaroverlay1.Visible = $true
	$progressbaroverlay1.Maximum = ($SelectedChecklists.count) * 10
	$progressbaroverlay1.Value = 0
	$progressbaroverlay1.Step = 10
	
	$script:ChecklistArray = @()
	foreach ($obj in $SelectedChecklists)
	{
		$Checklist = [XML] (Get-Content -Path "$($obj.fullname)")
		$VulnMap = $Checklist.CHECKLIST.STIGS.iSTIG.VULN.STIG_DATA
		$VulnArray = @()
		$i = 0 # Used to record the last entry
		foreach ($SubObj in $VulnMap)
		{
<#			$i++
			IF ($i -eq $VulnMap.count)
			{
				$VulnArray += $RemoteObj
			}
			
			IF ($SubObj.Vuln_Attribute -eq "Vuln_Num" -and $RemoteObj.Vuln_Num.Length -gt 0)
			{
				$VulnArray += $RemoteObj
			}
			
			IF ($SubObj.Vuln_Attribute -eq "Vuln_Num")
			{
				$RemoteObj = New-Object PSCustomObject
				$RemoteObj | Add-Member -MemberType NoteProperty -Name Checklist -Value $obj.name
				$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data
			}
			Else
			{
				$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data
			}#>
			
			<#if ($i -eq 0)
			{
				$RemoteObj = New-Object PSCustomObject
				$RemoteObj | Add-Member -MemberType NoteProperty -Name Checklist -Value $obj.name
				if ($SubObj.Vuln_Attribute.length -gt 0)
				{
					$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data
				}
				
			}#>
		
			
<#			if ($SubObj.Vuln_Attribute -eq "Vuln_Num" -and $RemoteObj -ne $null)
			{
				$VulnArray += $RemoteObj
				$saved = $true
			}#>
			
			if ($RemoteObj -eq $null) # Data added, create new object add checklist name
			{
				$RemoteObj = New-Object PSCustomObject
				$RemoteObj | Add-Member -MemberType NoteProperty -Name Checklist -Value $obj.name -force
			}
			
			if ($RemoteObj -ne $null)
			{
				$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data -Force #Add other data
			}
			$i++
			$remoteObjStatus = detailObject $RemoteObj
			if ($remoteObjStatus -eq 25)
			{
				$VulnArray += $RemoteObj
				$RemoteObj = $null
			}
			
			
			
<#			
			if ($SubObj.Vuln_Attribute -eq "Vuln_Num")
			{
				if ($i -ne 0)
				{
					$VulnArray += $RemoteObj
					$saved = $true
				}
				
				$RemoteObj | Add-Member -MemberType NoteProperty -Name Checklist -Value $obj.name
				$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data
			}
			elseif ($SubObj.Vuln_Attribute -ne "Vuln_Num")
			{
				$RemoteObj | Add-Member -MemberType NoteProperty -Name $SubObj.Vuln_Attribute -Value $SubObj.Attribute_Data
			}
			$i++
		if ($i -eq $VulnMap.Count)
			{
				$VulnArray += $RemoteObj
			}#>
			
		}
		
		$STIGStatus = $Checklist.CHECKLIST.STIGS.iSTIG.VULN
		$i = 0
		foreach ($VulnStatus in $STIGStatus)
		{
			$VulnArray[$i] | Add-Member -MemberType NoteProperty -Name Status -Value $VulnStatus.status
			$VulnArray[$i] | Add-Member -MemberType NoteProperty -Name Finding_Details -Value $VulnStatus.Finding_Details
			$VulnArray[$i] | Add-Member -MemberType NoteProperty -Name Comments -Value $VulnStatus.comments
			$i++
		}
		$script:ChecklistArray += $VulnArray
		$progressbaroverlay1.PerformStep()
	}
	
	$textboxChecklistCount.Text = ($script:ChecklistArray.Checklist | select -Unique).count
	$textboxOpenFindings.Text = ($script:ChecklistArray.Status | where { $_ -eq "Open" }).count
	$textboxNotReviewed.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Reviewed" }).count
	$textboxNotApplicable.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count
	$textboxNotaFinding.Text = ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count
	$textboxBlanks.Text = ($script:ChecklistArray.Status | where { $_.length -eq "0" }).count
	$textboxOpenVulnerabilities.Text = ($script:ChecklistArray).count
	$completion = ((($script:ChecklistArray.Status | where { $_ -eq "Open" }).count + ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$OpenVulns = ((($script:ChecklistArray.Status | Where {$_ -eq "Open"}).count + ($script:ChecklistArray.Status | where {$_ -eq "Not_Reviewed"}).count) / ($script:ChecklistArray).count) * 100
	$Compliance = ((($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$textboxCompletion.Text = $completion.ToString().Split(".")[0] +"%"
	$textboxCompliance.Text = $Compliance.ToString().Split(".")[0] +"%"
	$textboxOpenVulnerabilities.Text = $OpenVulns.ToString().Split(".")[0] + "%"
}

$buttonImportckl_Click = {
	$folderbrowserdialog1.ShowDialog()
	$script:AvailableChecklists = Get-ChildItem -Recurse -Path $folderbrowserdialog1.SelectedPath | where { $_.Name -like "*.ckl" } | select Name, Fullname
	Update-ListBox -ListBox $checkedlistbox1 -Items $script:AvailableChecklists.name
}

$buttonSelectAll_Click={
	$i = 0
	$count = $checkedlistbox1.Items.Count
	Do { $checkedlistbox1.SetItemChecked($i, $true); $i++ }
	Until ($i -eq ($count))
	
}

$buttonUnselectAll_Click={
	$i = 0
	$count = $checkedlistbox1.Items.Count
	Do { $checkedlistbox1.SetItemChecked($i, $false); $i++ }
	Until ($i -eq ($count))
	
}


$labelOpenFindings_Click={
	Show-Open_psf
	
}

$labelNotReviewed_Click={
	Show-NotReviewed_psf
	
}

$labelNotAFinding_Click={
	Show-NotAFinding_psf
	
}

$labelNotApplicable_Click={
	Show-NotApplicable_psf
	
}

$labelTotal_Click={
	#TODO: Place custom script here
	
}

$buttonExportCombinedCheckl_Click={
	$savefiledialog1.ShowDialog()
	Create-STIGXML -Path $savefiledialog1.FileName -Content $script:ChecklistArray
<#	$filepath = "$($savefiledialog1.Filename)-NEW.ckl"
	$xml = New-Object System.Xml.XMLDataDocument
	#$xml.PreserveWhitespace = $true
		$ElementCHECKLIST = $xml.CreateElement('CHECKLIST')
		$xml.AppendChild($ElementCHECKLIST) | Out-Null
		#CHECKLIST
		$ElementASSET = $xml.CreateElement('ASSET')
		$ElementSTIGS = $xml.CreateElement('STIGS')
		$ElementCHECKLIST.AppendChild($ElementASSET) | Out-Null
		$ElementCHECKLIST.AppendChild($ElementSTIGS) | Out-Null
		# ASSETS
		$ElementROLE = $xml.CreateElement('ROLE')
		$ElementASSET_TYPE = $xml.CreateElement('ASSET_TYPE')
		$ElementHOST_NAME = $xml.CreateElement('HOST_NAME')
		$ElementHOST_IP = $xml.CreateElement('HOST_IP')
		$ElementHOST_MAC = $xml.CreateElement('HOST_MAC')
		$ElementHOST_GUID = $xml.CreateElement('HOST_GUID')
		$ElementHOST_FQDN = $xml.CreateElement('HOST_FQDN')
		$ElementTECH_AREA = $xml.CreateElement('TECH_AREA')
		$ElementTARGET_KEY = $xml.CreateElement('TARGET_KEY')
		$ElementWEB_OR_DATABASE = $xml.CreateElement('WEB_OR_DATABASE')
		$ElementWEB_DB_SITE = $xml.CreateElement('WEB_DB_SITE')
		$ElementWEB_DB_INSTANCEE = $xml.CreateElement('WEB_DB_INSTANCE')
		$ElementASSET.AppendChild($ElementROLE) | Out-Null
		$ElementASSET.AppendChild($ElementASSET_TYPE) | Out-Null
		$ElementASSET.AppendChild($ElementHOST_NAME) | Out-Null
		$ElementASSET.AppendChild($ElementHOST_IP) | Out-Null
		$ElementASSET.AppendChild($ElementHOST_MAC) | Out-Null
		$ElementASSET.AppendChild($ElementHOST_GUID) | Out-Null
		$ElementASSET.AppendChild($ElementHOST_FQDN) | Out-Null
		$ElementASSET.AppendChild($ElementTECH_AREA) | Out-Null
		$ElementASSET.AppendChild($ElementTARGET_KEY) | Out-Null
		$ElementASSET.AppendChild($ElementWEB_OR_DATABASE) | Out-Null
		$ElementASSET.AppendChild($ElementWEB_DB_SITE) | Out-Null
		$ElementASSET.AppendChild($ElementWEB_DB_INSTANCEE) | Out-Null
		#STIGS
		$ElementiSTIG = $xml.CreateElement('iSTIG')
		$ElementSTIGS.AppendChild($ElementiSTIG) | Out-Null
		#STIG_INFO
		$ElementSTIG_INFO = $xml.CreateElement('STIG_INFO')
		$ElementiSTIG.AppendChild($ElementSTIG_INFO) | Out-Null
		#SI_DATA
		$ElementSI_DATA = $xml.CreateElement('SI_DATA')
		$ElementSTIG_INFO.AppendChild($ElementSI_DATA) | Out-Null
		#SID_NAME
		$ElementSID_NAME = $xml.CreateElement('SID_NAME')
		$ElementSI_DATA.AppendChild($ElementSID_NAME) | Out-Null
		#SID_DATA
		$ElementSID_DATA = $xml.CreateElement('SID_DATA')
		$ElementSI_DATA.AppendChild($ElementSID_DATA) | Out-Null
	
	$path = $filepath
	$VulnMap = $script:ChecklistArray
	$VulnArray = @()
	foreach ($SubObj in $VulnMap)
	{
		#iSTIG
		$ElementVULN = $xml.CreateElement('VULN')
		$ElementiSTIG.AppendChild($ElementVULN) | Out-Null
		
		#VULN
		$ElementSTIG_DATA = $xml.CreateElement('STIG_DATA')
		$ElementSTATUS = $xml.CreateElement('STATUS')
		$ElementSTATUS.InnerText = $SubObj.STATUS
		$ElementFINDING_DETAILS = $xml.CreateElement('FINDING_DETAILS')
		$ElementFINDING_DETAILS.InnerText = $SubObj.FINDING_DETAILS
		$ElementCOMMENTS = $xml.CreateElement('COMMENTS')
		$ElementCOMMENTS.InnerText = $SubObj.COMMENTS
		$ElementSEVERITY_OVERRIDE = $xml.CreateElement('SEVERITY_OVERRIDE')
		$ElementSEVERITY_OVERRIDE.InnerText = $SubObj.SEVERITY_OVERRIDE
		$ElementSEVERITY_JUSTIFICATION = $xml.CreateElement('SEVERITY_JUSTIFICATION')
		$ElementSEVERITY_JUSTIFICATION.InnerText = $SubObj.SEVERITY_JUSTIFICATION
		$ElementVULN.AppendChild($ElementSTIG_DATA) | Out-Null
		$ElementVULN.AppendChild($ElementSTATUS) | Out-Null
		$ElementVULN.AppendChild($ElementFINDING_DETAILS) | Out-Null
		$ElementVULN.AppendChild($ElementCOMMENTS) | Out-Null
		$ElementVULN.AppendChild($ElementSEVERITY_OVERRIDE) | Out-Null
		$ElementVULN.AppendChild($ElementSEVERITY_JUSTIFICATION) | Out-Null
		foreach ($obj IN $SubObj)
		{
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Vuln_Num"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Vuln_Num
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Severity"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Severity
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Group_Title"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Group_Title
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Rule_ID"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Rule_ID
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Rule_Ver"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Rule_Ver
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Rule_Title"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Rule_Title
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Vuln_Discuss"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Vuln_Discuss
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "IA_Controls"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.IA_Controls
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Check_Content"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Check_Content
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Fix_Text"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Fix_Text
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "False_Positives"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.False_Positives
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "False_Negatives"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.False_Negatives
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Documentable"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Documentable
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Mitigations"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Mitigations
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Potential_Impact"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Potential_Impact
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Third_Party_Tools"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Third_Party_Tools
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Mitigation_Control"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Mitigation_Control
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Responsibility"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Responsibility
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Security_Override_Guidance"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Security_Override_Guidance
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Check_Content_Ref"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Check_Content_Ref
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "Class"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.Class
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "STIGRef"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.STIGRef
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "TargetKey"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.TargetKey
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
			#SUB-STIG_DATA
			$ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
			$ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
			#VULN_ATTRIBUTE
			$ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
			$ElementVULN_ATTRIBUTE.InnerText = "CCI_REF"
			#ATTRIBUTE_DATA
			$ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
			$ElementATTRIBUTE_DATA.InnerText = $obj.CCI_REF
			# ADD TO XML TREE
			$ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
			$ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
			
		}
	}
	$writerXML = [System.Xml.XmlWriter]::Create($filepath)
	#$xmlSettings = [System.Xml.XmlWriterSettings]::($writerXML)
	#$xmlSettings.Indent = $true
	#$xmlSettings.NewLineOnAttributes = $true
	$XML.Save($writerXML)#>
	
}

$buttonExportCombinedCSV_Click={
	$savefiledialog1.ShowDialog()
	$script:ChecklistArray | Export-Csv -path "$($savefiledialog1.Filename).csv" -Force -NoTypeInformation
}

$buttonModifyChecklists_Click={
	Show-ModifyChecklists_psf
	
}


$buttonProcessModified_Click = {
	$script:ChecklistArray = $script:NewArray
	$textboxChecklistCount.Text = ($script:ChecklistArray.Checklist | select -Unique).count
	$textboxOpenFindings.Text = ($script:ChecklistArray.Status | where { $_ -eq "Open" }).count
	$textboxNotReviewed.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Reviewed" }).count
	$textboxNotApplicable.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count
	$textboxNotaFinding.Text = ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count
	$textboxBlanks.Text = ($script:ChecklistArray.Status | where { $_.length -eq "0" }).count
	$textboxOpenVulnerabilities.Text = ($script:ChecklistArray).count
	$completion = ((($script:ChecklistArray.Status | where { $_ -eq "Open" }).count + ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$OpenVulns = ((($script:ChecklistArray.Status | Where { $_ -eq "Open" }).count + ($script:ChecklistArray.Status | where { $_ -eq "Not_Reviewed" }).count) / ($script:ChecklistArray).count) * 100
	$Compliance = ((($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$textboxCompletion.Text = $completion.ToString().Split(".")[0] + "%"
	$textboxCompliance.Text = $Compliance.ToString().Split(".")[0] + "%"
	$textboxOpenVulnerabilities.Text = $OpenVulns.ToString().Split(".")[0] + "%"
		
}

$buttonImportCSV_Click = {
	$openfiledialog1.ShowDialog()
	$script:ChecklistArray = Import-Csv -Path $openfiledialog1.FileName
	$script:ChecklistArray = $script:ChecklistArray | where {$_.Vuln_Num.length -gt 0}
	$textboxChecklistCount.Text = ($script:ChecklistArray.Checklist | select -Unique).count
	$textboxOpenFindings.Text = ($script:ChecklistArray.Status | where { $_ -eq "Open" }).count
	$textboxNotReviewed.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Reviewed" }).count
	$textboxNotApplicable.Text = ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count
	$textboxNotaFinding.Text = ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count
	$textboxBlanks.Text = ($script:ChecklistArray.Status | where { $_.length -eq "0" }).count
	$textboxOpenVulnerabilities.Text = ($script:ChecklistArray).count
	$completion = ((($script:ChecklistArray.Status | where { $_ -eq "Open" }).count + ($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$OpenVulns = ((($script:ChecklistArray.Status | Where { $_ -eq "Open" }).count + ($script:ChecklistArray.Status | where { $_ -eq "Not_Reviewed" }).count) / ($script:ChecklistArray).count) * 100
	$Compliance = ((($script:ChecklistArray.Status | where { $_ -eq "Not_Applicable" }).count + ($script:ChecklistArray.Status | where { $_ -eq "NotAFinding" }).count) / ($script:ChecklistArray).count) * 100
	$textboxCompletion.Text = $completion.ToString().Split(".")[0] + "%"
	$textboxCompliance.Text = $Compliance.ToString().Split(".")[0] + "%"
	$textboxOpenVulnerabilities.Text = $OpenVulns.ToString().Split(".")[0] + "%"
	
}

$labelBlankStatus_Click={
	Show-Blanks_psf
	
	
}
