function Set-CMApplicationContent {
    param
    (
    $target,
    $ContentLocation

    )
        Set-CMQueryResultMaximum -maximum 10000
        if($target.length -gt 0) {
            $ApplicationName = Get-CMApplication -Name "$target"
        }
        else
        {
            $ApplicationName = Get-CMApplication
        }

        $ApplicationName = $ApplicationName.LocalizedDisplayName
        ## Build DT array
        $DTarray = @()
        ForEach($x in $ApplicationName) 
         { 
             $DeploymentTypeName = Get-CMDeploymentType -ApplicationName $x 
             #$DeploymentTypeName = $DeploymentTypeName.LocalizedDisplayName
             
                ForEach($DT in $DeploymentTypeName | where {$_.islatest -eq $true}) 
                { 
                ## Change the directory path to the new location 
                $DTSDMPackageXLM = $DT.SDMPackageXML 
                $DTSDMPackageXLM = [XML]$DTSDMPackageXLM 
            
                ## Validate if there are multiple DTs
                $DTloop = $DTSDMPackageXLM.AppMgmtDigest.DeploymentType.Installer.Contents.Content.location
                $DTcount = ($DTSDMPackageXLM.AppMgmtDigest.DeploymentType.Installer.Contents.Content).count

                ## Multiple DT
                if ($DTcount -gt 1) 
                {
                        $DTIndex = 0
                        Foreach ($obj in $DTloop)
                        {
                            $DTObject = New-Object PSCustomObject
                            $DTObject | Add-Member -MemberType NoteProperty -Name ApplicationName -Value $x 
                            $DTObject | Add-Member -MemberType NoteProperty -Name DeploymentTypeName -Value $DT.LocalizedDisplayName
                            $DTObject | Add-Member -MemberType NoteProperty -Name Location -Value $DTSDMPackageXLM.AppMgmtDigest.DeploymentType.Installer.Contents.Content.Location[$DTindex]
                            $DTarray += $DTObject
                            $DTIndex++
                        }
                 }
                 else ##Single DT
                 {
                        $DTObject = New-Object PSCustomObject
                        $DTObject | Add-Member -MemberType NoteProperty -Name ApplicationName -Value $x 
                        $DTObject | Add-Member -MemberType NoteProperty -Name DeploymentTypeName -Value $DT.LocalizedDisplayName
                        $DTObject | Add-Member -MemberType NoteProperty -Name Location -Value $DTSDMPackageXLM.AppMgmtDigest.DeploymentType.Installer.Contents.Content.Location
                        $DTarray += $DTObject

                 }
         }

    }
    ## Change location
    Foreach ($obj in $DTarray)
    {
        Set-CMDeploymentType -ApplicationName "$($obj.ApplicationName)" -DeploymentTypeName "$($obj.DeploymentTypeName)" -MsiOrScriptInstaller -ContentLocation "$ContentLocation"
    }

}