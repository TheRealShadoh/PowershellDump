#------------------------------------------------------------------------
# Source File Information (DO NOT MODIFY)
# Source ID: 89f68ba4-b291-4f92-8ca9-1682ce6f7326
# Source File: C:\Users\Administrator\Documents\SAPIEN\PowerShell Studio\Projects\STIGexamine\MainForm.psf
#------------------------------------------------------------------------



#----------------------------------------------
#region Application Functions
#----------------------------------------------

#endregion Application Functions

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Show-MainForm_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Define SAPIEN Types
	#----------------------------------------------
	try{
		[ProgressBarOverlay] | Out-Null
	}
	catch
	{
		Add-Type -ReferencedAssemblies ('System.Windows.Forms', 'System.Drawing') -TypeDefinition  @" 
		using System;
		using System.Windows.Forms;
		using System.Drawing;
        namespace SAPIENTypes
        {
		    public class ProgressBarOverlay : System.Windows.Forms.ProgressBar
	        {
                public ProgressBarOverlay() : base() { SetStyle(ControlStyles.OptimizedDoubleBuffer | ControlStyles.AllPaintingInWmPaint, true); }
	            protected override void WndProc(ref Message m)
	            { 
	                base.WndProc(ref m);
	                if (m.Msg == 0x000F)// WM_PAINT
	                {
	                    if (Style != System.Windows.Forms.ProgressBarStyle.Marquee || !string.IsNullOrEmpty(this.Text))
                        {
                            using (Graphics g = this.CreateGraphics())
                            {
                                using (StringFormat stringFormat = new StringFormat(StringFormatFlags.NoWrap))
                                {
                                    stringFormat.Alignment = StringAlignment.Center;
                                    stringFormat.LineAlignment = StringAlignment.Center;
                                    if (!string.IsNullOrEmpty(this.Text))
                                        g.DrawString(this.Text, this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
                                    else
                                    {
                                        int percent = (int)(((double)Value / (double)Maximum) * 100);
                                        g.DrawString(percent.ToString() + "%", this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
                                    }
                                }
                            }
                        }
	                }
	            }
              
                public string TextOverlay
                {
                    get
                    {
                        return base.Text;
                    }
                    set
                    {
                        base.Text = value;
                        Invalidate();
                    }
                }
	        }
        }
"@ -IgnoreWarnings | Out-Null
	}
	#endregion Define SAPIEN Types

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$STIGExamine = New-Object 'System.Windows.Forms.Form'
	$labelBlankStatus = New-Object 'System.Windows.Forms.Label'
	$textboxBlanks = New-Object 'System.Windows.Forms.TextBox'
	$buttonProcessModified = New-Object 'System.Windows.Forms.Button'
	$progressbaroverlay1 = New-Object 'SAPIENTypes.ProgressBarOverlay'
	$labelChristianCrillEngili = New-Object 'System.Windows.Forms.Label'
	$labelOpenVulnerabilities = New-Object 'System.Windows.Forms.Label'
	$labelSTIGCompliance = New-Object 'System.Windows.Forms.Label'
	$textboxCompliance = New-Object 'System.Windows.Forms.TextBox'
	$labelCompletionStatus = New-Object 'System.Windows.Forms.Label'
	$textboxCompletion = New-Object 'System.Windows.Forms.TextBox'
	$buttonImportCSV = New-Object 'System.Windows.Forms.Button'
	$richtextboxNotes = New-Object 'System.Windows.Forms.RichTextBox'
	$buttonModifyChecklists = New-Object 'System.Windows.Forms.Button'
	$buttonExportCombinedCSV = New-Object 'System.Windows.Forms.Button'
	$buttonExportCombinedCheckl = New-Object 'System.Windows.Forms.Button'
	$textboxOpenVulnerabilities = New-Object 'System.Windows.Forms.TextBox'
	$labelChecklistsScanned = New-Object 'System.Windows.Forms.Label'
	$textboxChecklistCount = New-Object 'System.Windows.Forms.TextBox'
	$labelNotApplicable = New-Object 'System.Windows.Forms.Label'
	$textboxNotApplicable = New-Object 'System.Windows.Forms.TextBox'
	$labelNotAFinding = New-Object 'System.Windows.Forms.Label'
	$textboxNotaFinding = New-Object 'System.Windows.Forms.TextBox'
	$labelNotReviewed = New-Object 'System.Windows.Forms.Label'
	$textboxNotReviewed = New-Object 'System.Windows.Forms.TextBox'
	$labelOpenFindings = New-Object 'System.Windows.Forms.Label'
	$textboxOpenFindings = New-Object 'System.Windows.Forms.TextBox'
	$buttonUnselectAll = New-Object 'System.Windows.Forms.Button'
	$buttonSelectAll = New-Object 'System.Windows.Forms.Button'
	$buttonProcess = New-Object 'System.Windows.Forms.Button'
	$checkedlistbox1 = New-Object 'System.Windows.Forms.CheckedListBox'
	$buttonImportckl = New-Object 'System.Windows.Forms.Button'
	$folderbrowserdialog1 = New-Object 'System.Windows.Forms.FolderBrowserDialog'
	$savefiledialog1 = New-Object 'System.Windows.Forms.SaveFileDialog'
	$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
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
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$STIGExamine.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$labelBlankStatus.remove_Click($labelBlankStatus_Click)
			$buttonProcessModified.remove_Click($buttonProcessModified_Click)
			$buttonImportCSV.remove_Click($buttonImportCSV_Click)
			$buttonModifyChecklists.remove_Click($buttonModifyChecklists_Click)
			$buttonExportCombinedCSV.remove_Click($buttonExportCombinedCSV_Click)
			$buttonExportCombinedCheckl.remove_Click($buttonExportCombinedCheckl_Click)
			$labelNotApplicable.remove_Click($labelNotApplicable_Click)
			$labelNotAFinding.remove_Click($labelNotAFinding_Click)
			$labelNotReviewed.remove_Click($labelNotReviewed_Click)
			$labelOpenFindings.remove_Click($labelOpenFindings_Click)
			$buttonUnselectAll.remove_Click($buttonUnselectAll_Click)
			$buttonSelectAll.remove_Click($buttonSelectAll_Click)
			$buttonProcess.remove_Click($buttonProcess_Click)
			$buttonImportckl.remove_Click($buttonImportckl_Click)
			$STIGExamine.remove_Load($STIGExamine_Load)
			$STIGExamine.remove_Load($Form_StateCorrection_Load)
			$STIGExamine.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$STIGExamine.SuspendLayout()
	#
	# STIGExamine
	#
	$STIGExamine.Controls.Add($labelBlankStatus)
	$STIGExamine.Controls.Add($textboxBlanks)
	$STIGExamine.Controls.Add($buttonProcessModified)
	$STIGExamine.Controls.Add($progressbaroverlay1)
	$STIGExamine.Controls.Add($labelChristianCrillEngili)
	$STIGExamine.Controls.Add($labelOpenVulnerabilities)
	$STIGExamine.Controls.Add($labelSTIGCompliance)
	$STIGExamine.Controls.Add($textboxCompliance)
	$STIGExamine.Controls.Add($labelCompletionStatus)
	$STIGExamine.Controls.Add($textboxCompletion)
	$STIGExamine.Controls.Add($buttonImportCSV)
	$STIGExamine.Controls.Add($richtextboxNotes)
	$STIGExamine.Controls.Add($buttonModifyChecklists)
	$STIGExamine.Controls.Add($buttonExportCombinedCSV)
	$STIGExamine.Controls.Add($buttonExportCombinedCheckl)
	$STIGExamine.Controls.Add($textboxOpenVulnerabilities)
	$STIGExamine.Controls.Add($labelChecklistsScanned)
	$STIGExamine.Controls.Add($textboxChecklistCount)
	$STIGExamine.Controls.Add($labelNotApplicable)
	$STIGExamine.Controls.Add($textboxNotApplicable)
	$STIGExamine.Controls.Add($labelNotAFinding)
	$STIGExamine.Controls.Add($textboxNotaFinding)
	$STIGExamine.Controls.Add($labelNotReviewed)
	$STIGExamine.Controls.Add($textboxNotReviewed)
	$STIGExamine.Controls.Add($labelOpenFindings)
	$STIGExamine.Controls.Add($textboxOpenFindings)
	$STIGExamine.Controls.Add($buttonUnselectAll)
	$STIGExamine.Controls.Add($buttonSelectAll)
	$STIGExamine.Controls.Add($buttonProcess)
	$STIGExamine.Controls.Add($checkedlistbox1)
	$STIGExamine.Controls.Add($buttonImportckl)
	$STIGExamine.AutoScaleDimensions = '6, 13'
	$STIGExamine.AutoScaleMode = 'Font'
	$STIGExamine.ClientSize = '727, 446'
	$STIGExamine.Name = 'STIGExamine'
	$STIGExamine.Text = 'STIG Examine v1.0.0.10'
	$STIGExamine.add_Load($STIGExamine_Load)
	#
	# labelBlankStatus
	#
	$labelBlankStatus.AutoSize = $True
	$labelBlankStatus.Font = 'Microsoft Sans Serif, 8.25pt, style=Underline'
	$labelBlankStatus.ForeColor = 'Red'
	$labelBlankStatus.Location = '538, 131'
	$labelBlankStatus.Name = 'labelBlankStatus'
	$labelBlankStatus.Size = '67, 13'
	$labelBlankStatus.TabIndex = 38
	$labelBlankStatus.Text = 'Blank Status'
	$labelBlankStatus.add_Click($labelBlankStatus_Click)
	#
	# textboxBlanks
	#
	$textboxBlanks.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxBlanks.ForeColor = 'Red'
	$textboxBlanks.Location = '610, 128'
	$textboxBlanks.Name = 'textboxBlanks'
	$textboxBlanks.ReadOnly = $True
	$textboxBlanks.Size = '100, 20'
	$textboxBlanks.TabIndex = 37
	#
	# buttonProcessModified
	#
	$buttonProcessModified.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonProcessModified.Location = '596, 258'
	$buttonProcessModified.Name = 'buttonProcessModified'
	$buttonProcessModified.Size = '114, 24'
	$buttonProcessModified.TabIndex = 6
	$buttonProcessModified.Text = 'Process Modified'
	$buttonProcessModified.UseVisualStyleBackColor = $True
	$buttonProcessModified.add_Click($buttonProcessModified_Click)
	#
	# progressbaroverlay1
	#
	$progressbaroverlay1.Location = '408, 338'
	$progressbaroverlay1.Name = 'progressbaroverlay1'
	$progressbaroverlay1.Size = '302, 23'
	$progressbaroverlay1.TabIndex = 36
	#
	# labelChristianCrillEngili
	#
	$labelChristianCrillEngili.AutoSize = $True
	$labelChristianCrillEngili.Location = '12, 428'
	$labelChristianCrillEngili.Name = 'labelChristianCrillEngili'
	$labelChristianCrillEngili.Size = '133, 13'
	$labelChristianCrillEngili.TabIndex = 35
	$labelChristianCrillEngili.Text = 'Christian Crill - Engility Corp'
	#
	# labelOpenVulnerabilities
	#
	$labelOpenVulnerabilities.AutoSize = $True
	$labelOpenVulnerabilities.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelOpenVulnerabilities.ForeColor = 'Red'
	$labelOpenVulnerabilities.Location = '485, 95'
	$labelOpenVulnerabilities.Name = 'labelOpenVulnerabilities'
	$labelOpenVulnerabilities.Size = '120, 13'
	$labelOpenVulnerabilities.TabIndex = 34
	$labelOpenVulnerabilities.Text = 'Open Vulnerabilities'
	#
	# labelSTIGCompliance
	#
	$labelSTIGCompliance.AutoSize = $True
	$labelSTIGCompliance.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelSTIGCompliance.ForeColor = 'Black'
	$labelSTIGCompliance.Location = '500, 69'
	$labelSTIGCompliance.Name = 'labelSTIGCompliance'
	$labelSTIGCompliance.Size = '105, 13'
	$labelSTIGCompliance.TabIndex = 33
	$labelSTIGCompliance.Text = 'STIG Compliance'
	#
	# textboxCompliance
	#
	$textboxCompliance.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxCompliance.Location = '610, 65'
	$textboxCompliance.Name = 'textboxCompliance'
	$textboxCompliance.ReadOnly = $True
	$textboxCompliance.Size = '100, 20'
	$textboxCompliance.TabIndex = 32
	#
	# labelCompletionStatus
	#
	$labelCompletionStatus.AutoSize = $True
	$labelCompletionStatus.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelCompletionStatus.ForeColor = 'Black'
	$labelCompletionStatus.Location = '496, 43'
	$labelCompletionStatus.Name = 'labelCompletionStatus'
	$labelCompletionStatus.Size = '109, 13'
	$labelCompletionStatus.TabIndex = 31
	$labelCompletionStatus.Text = 'Completion Status'
	#
	# textboxCompletion
	#
	$textboxCompletion.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxCompletion.Location = '610, 40'
	$textboxCompletion.Name = 'textboxCompletion'
	$textboxCompletion.ReadOnly = $True
	$textboxCompletion.Size = '100, 20'
	$textboxCompletion.TabIndex = 30
	#
	# buttonImportCSV
	#
	$buttonImportCSV.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonImportCSV.Location = '300, 43'
	$buttonImportCSV.Name = 'buttonImportCSV'
	$buttonImportCSV.Size = '84, 23'
	$buttonImportCSV.TabIndex = 2
	$buttonImportCSV.Text = 'Import CSV'
	$buttonImportCSV.UseVisualStyleBackColor = $True
	$buttonImportCSV.add_Click($buttonImportCSV_Click)
	#
	# richtextboxNotes
	#
	$richtextboxNotes.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$richtextboxNotes.ForeColor = 'Red'
	$richtextboxNotes.Location = '408, 367'
	$richtextboxNotes.Name = 'richtextboxNotes'
	$richtextboxNotes.ReadOnly = $True
	$richtextboxNotes.Size = '302, 57'
	$richtextboxNotes.TabIndex = 28
	$richtextboxNotes.Text = 'Contact Chris Crill for issues //  If exporting a combined checklist or csv, there is no DeDup currently.'
	#
	# buttonModifyChecklists
	#
	$buttonModifyChecklists.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonModifyChecklists.Location = '476, 258'
	$buttonModifyChecklists.Name = 'buttonModifyChecklists'
	$buttonModifyChecklists.Size = '114, 24'
	$buttonModifyChecklists.TabIndex = 5
	$buttonModifyChecklists.Text = 'Modify Checklists'
	$buttonModifyChecklists.UseVisualStyleBackColor = $True
	$buttonModifyChecklists.add_Click($buttonModifyChecklists_Click)
	#
	# buttonExportCombinedCSV
	#
	$buttonExportCombinedCSV.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonExportCombinedCSV.Location = '300, 118'
	$buttonExportCombinedCSV.Name = 'buttonExportCombinedCSV'
	$buttonExportCombinedCSV.Size = '114, 34'
	$buttonExportCombinedCSV.TabIndex = 4
	$buttonExportCombinedCSV.Text = 'Export Combined CSV'
	$buttonExportCombinedCSV.UseVisualStyleBackColor = $True
	$buttonExportCombinedCSV.add_Click($buttonExportCombinedCSV_Click)
	#
	# buttonExportCombinedCheckl
	#
	$buttonExportCombinedCheckl.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonExportCombinedCheckl.Location = '300, 78'
	$buttonExportCombinedCheckl.Name = 'buttonExportCombinedCheckl'
	$buttonExportCombinedCheckl.Size = '114, 34'
	$buttonExportCombinedCheckl.TabIndex = 3
	$buttonExportCombinedCheckl.Text = 'Export Combined Checklist'
	$buttonExportCombinedCheckl.UseVisualStyleBackColor = $True
	$buttonExportCombinedCheckl.add_Click($buttonExportCombinedCheckl_Click)
	#
	# textboxOpenVulnerabilities
	#
	$textboxOpenVulnerabilities.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxOpenVulnerabilities.ForeColor = 'Red'
	$textboxOpenVulnerabilities.Location = '610, 92'
	$textboxOpenVulnerabilities.Name = 'textboxOpenVulnerabilities'
	$textboxOpenVulnerabilities.ReadOnly = $True
	$textboxOpenVulnerabilities.Size = '100, 20'
	$textboxOpenVulnerabilities.TabIndex = 23
	#
	# labelChecklistsScanned
	#
	$labelChecklistsScanned.AutoSize = $True
	$labelChecklistsScanned.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$labelChecklistsScanned.Location = '486, 19'
	$labelChecklistsScanned.Name = 'labelChecklistsScanned'
	$labelChecklistsScanned.Size = '119, 13'
	$labelChecklistsScanned.TabIndex = 22
	$labelChecklistsScanned.Text = 'Checklists Scanned'
	#
	# textboxChecklistCount
	#
	$textboxChecklistCount.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxChecklistCount.Location = '610, 16'
	$textboxChecklistCount.Name = 'textboxChecklistCount'
	$textboxChecklistCount.ReadOnly = $True
	$textboxChecklistCount.Size = '100, 20'
	$textboxChecklistCount.TabIndex = 21
	#
	# labelNotApplicable
	#
	$labelNotApplicable.AutoSize = $True
	$labelNotApplicable.Font = 'Microsoft Sans Serif, 8.25pt, style=Underline'
	$labelNotApplicable.ForeColor = 'Blue'
	$labelNotApplicable.Location = '529, 235'
	$labelNotApplicable.Name = 'labelNotApplicable'
	$labelNotApplicable.Size = '76, 13'
	$labelNotApplicable.TabIndex = 20
	$labelNotApplicable.Text = 'Not Applicable'
	$labelNotApplicable.add_Click($labelNotApplicable_Click)
	#
	# textboxNotApplicable
	#
	$textboxNotApplicable.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxNotApplicable.Location = '610, 232'
	$textboxNotApplicable.Name = 'textboxNotApplicable'
	$textboxNotApplicable.ReadOnly = $True
	$textboxNotApplicable.Size = '100, 20'
	$textboxNotApplicable.TabIndex = 19
	#
	# labelNotAFinding
	#
	$labelNotAFinding.AutoSize = $True
	$labelNotAFinding.Font = 'Microsoft Sans Serif, 8.25pt, style=Underline'
	$labelNotAFinding.ForeColor = 'Blue'
	$labelNotAFinding.Location = '535, 209'
	$labelNotAFinding.Name = 'labelNotAFinding'
	$labelNotAFinding.Size = '70, 13'
	$labelNotAFinding.TabIndex = 18
	$labelNotAFinding.Text = 'Not a Finding'
	$labelNotAFinding.add_Click($labelNotAFinding_Click)
	#
	# textboxNotaFinding
	#
	$textboxNotaFinding.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxNotaFinding.ForeColor = '0, 192, 0'
	$textboxNotaFinding.Location = '610, 206'
	$textboxNotaFinding.Name = 'textboxNotaFinding'
	$textboxNotaFinding.ReadOnly = $True
	$textboxNotaFinding.Size = '100, 20'
	$textboxNotaFinding.TabIndex = 17
	#
	# labelNotReviewed
	#
	$labelNotReviewed.AutoSize = $True
	$labelNotReviewed.Font = 'Microsoft Sans Serif, 8.25pt, style=Underline'
	$labelNotReviewed.ForeColor = 'Blue'
	$labelNotReviewed.Location = '530, 183'
	$labelNotReviewed.Name = 'labelNotReviewed'
	$labelNotReviewed.Size = '75, 13'
	$labelNotReviewed.TabIndex = 16
	$labelNotReviewed.Text = 'Not Reviewed'
	$labelNotReviewed.add_Click($labelNotReviewed_Click)
	#
	# textboxNotReviewed
	#
	$textboxNotReviewed.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxNotReviewed.ForeColor = '255, 128, 0'
	$textboxNotReviewed.Location = '610, 180'
	$textboxNotReviewed.Name = 'textboxNotReviewed'
	$textboxNotReviewed.ReadOnly = $True
	$textboxNotReviewed.Size = '100, 20'
	$textboxNotReviewed.TabIndex = 15
	#
	# labelOpenFindings
	#
	$labelOpenFindings.AutoSize = $True
	$labelOpenFindings.Font = 'Microsoft Sans Serif, 8.25pt, style=Underline'
	$labelOpenFindings.ForeColor = 'Blue'
	$labelOpenFindings.Location = '530, 157'
	$labelOpenFindings.Name = 'labelOpenFindings'
	$labelOpenFindings.Size = '75, 13'
	$labelOpenFindings.TabIndex = 14
	$labelOpenFindings.Text = 'Open Findings'
	$labelOpenFindings.add_Click($labelOpenFindings_Click)
	#
	# textboxOpenFindings
	#
	$textboxOpenFindings.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$textboxOpenFindings.ForeColor = 'Red'
	$textboxOpenFindings.Location = '610, 154'
	$textboxOpenFindings.Name = 'textboxOpenFindings'
	$textboxOpenFindings.ReadOnly = $True
	$textboxOpenFindings.Size = '100, 20'
	$textboxOpenFindings.TabIndex = 6
	#
	# buttonUnselectAll
	#
	$buttonUnselectAll.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonUnselectAll.Location = '206, 398'
	$buttonUnselectAll.Name = 'buttonUnselectAll'
	$buttonUnselectAll.Size = '88, 23'
	$buttonUnselectAll.TabIndex = 5
	$buttonUnselectAll.Text = 'Unselect All'
	$buttonUnselectAll.UseVisualStyleBackColor = $True
	$buttonUnselectAll.add_Click($buttonUnselectAll_Click)
	#
	# buttonSelectAll
	#
	$buttonSelectAll.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonSelectAll.Location = '12, 398'
	$buttonSelectAll.Name = 'buttonSelectAll'
	$buttonSelectAll.Size = '88, 23'
	$buttonSelectAll.TabIndex = 4
	$buttonSelectAll.Text = 'Select All'
	$buttonSelectAll.UseVisualStyleBackColor = $True
	$buttonSelectAll.add_Click($buttonSelectAll_Click)
	#
	# buttonProcess
	#
	$buttonProcess.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonProcess.Location = '390, 13'
	$buttonProcess.Name = 'buttonProcess'
	$buttonProcess.Size = '61, 23'
	$buttonProcess.TabIndex = 1
	$buttonProcess.Text = 'Process'
	$buttonProcess.UseVisualStyleBackColor = $True
	$buttonProcess.add_Click($buttonProcess_Click)
	#
	# checkedlistbox1
	#
	$checkedlistbox1.FormattingEnabled = $True
	$checkedlistbox1.Location = '12, 13'
	$checkedlistbox1.Name = 'checkedlistbox1'
	$checkedlistbox1.Size = '282, 379'
	$checkedlistbox1.TabIndex = 1
	#
	# buttonImportckl
	#
	$buttonImportckl.Font = 'Microsoft Sans Serif, 8.25pt, style=Bold'
	$buttonImportckl.Location = '300, 13'
	$buttonImportckl.Name = 'buttonImportckl'
	$buttonImportckl.Size = '84, 23'
	$buttonImportckl.TabIndex = 0
	$buttonImportckl.Text = 'Import CKL'
	$buttonImportckl.UseVisualStyleBackColor = $True
	$buttonImportckl.add_Click($buttonImportckl_Click)
	#
	# folderbrowserdialog1
	#
	#
	# savefiledialog1
	#
	#
	# openfiledialog1
	#
	$openfiledialog1.FileName = 'openfiledialog1'
	$STIGExamine.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $STIGExamine.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$STIGExamine.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$STIGExamine.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $STIGExamine.ShowDialog()

} #End Function

#Call the form
Show-MainForm_psf | Out-Null
