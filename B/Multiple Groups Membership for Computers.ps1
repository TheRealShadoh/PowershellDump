$Groups = Get-ADGroup -SearchBase "OU" -Filter * | Where {$_.Name -like "T00*"}

ForEach ($Group in $Groups)
{
    $GName = $Group.Name

    $Path = "C:\Users\\Desktop\Office\$GName Membership.xlsx"

    $a = New-Object -comobject Excel.Application
    $a.visible = $True

    $b = $a.Workbooks.Add()
    $c = $b.Worksheets.Item(1)

    $c.Cells.Item(1,1) = "Computer"
    $c.Cells.Item(1,2) = "Computer OU"

    $d = $c.UsedRange
    $d.Interior.ColorIndex = 19
    $d.Font.ColorIndex = 11
    $d.Font.Bold = $True

    $intRow = 2

    $Names = Get-ADGroupMember -Identity $Group.SamAccountName | Select *
    ForEach ($Computer in $Names)
    {
        $AD = Get-ADComputer -Identity $Computer.name -Properties CanonicalName
        $OU = $AD.CanonicalName
        $c.Cells.Item($intRow,1) = $Computer.name
        $c.Cells.Item($intRow,2) = $OU
        $intRow = $intRow + 1
    }

    $d.EntireColumn.AutoFit()

    $b.SaveAs($Path)
    $b.Close()

    $a.Quit()
}