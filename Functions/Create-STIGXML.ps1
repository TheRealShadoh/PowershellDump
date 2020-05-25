function Create-STIGXML
{
	param (
		$Path,
		$Content
		
	)
	$filepath = "$path.ckl"
	$path = $filepath
	
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
	
	#$VulnMap = $input
	$VulnArray = @()
	foreach ($SubObj in $Content)
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
	$writerXML = [System.Xml.XmlWriter]::Create($path)
	#$xmlSettings = [System.Xml.XmlWriterSettings]::($writerXML)
	#$xmlSettings.Indent = $true
	#$xmlSettings.NewLineOnAttributes = $true
	$XML.Save($writerXML)
}
