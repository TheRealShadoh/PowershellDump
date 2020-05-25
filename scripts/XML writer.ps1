cls
$filepath = "C:\users\Administrator\Desktop\STIG\Checklists\test.ckl"
$xml = New-Object System.Xml.XMLDataDocument
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

$path = 'C:\Users\Administrator\Desktop\STIG\Checklists\VSE - IPDS and Firewall Checklist__10-OCT-2017.ckl'
$Checklist = [XML] (Get-Content -Path "$path")
$VulnMap = $Checklist.CHECKLIST.STIGS.iSTIG.VULN
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
        foreach ($obj IN $SubObj.STIG_DATA) 
        {
            #SUB-STIG_DATA
            $ElementSUB_STIG_DATA = $xml.CreateElement('STIG_DATA')
            $ElementVULN.AppendChild($ElementSUB_STIG_DATA) | Out-Null
            #VULN_ATTRIBUTE
            $ElementVULN_ATTRIBUTE = $xml.CreateElement('VULN_ATTRIBUTE')
            $ElementVULN_ATTRIBUTE.InnerText = $obj.VULN_ATTRIBUTE
            #ATTRIBUTE_DATA
            $ElementATTRIBUTE_DATA = $xml.CreateElement('ATTRIBUTE_DATA')
            $ElementATTRIBUTE_DATA.InnerText = $obj.ATTRIBUTE_DATA
            $ElementSUB_STIG_DATA.AppendChild($ElementVULN_ATTRIBUTE) | Out-Null
            $ElementSUB_STIG_DATA.AppendChild($ElementATTRIBUTE_DATA) | Out-Null
          
        }
}

 $XML.Save($filepath)
