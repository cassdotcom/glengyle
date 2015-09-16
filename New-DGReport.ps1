$dataTable = Data {
ConvertFrom-StringData @'
    FY1Runs_Out=S:\\WOP 15-16\\FY1 Runs - Outputs
    FY5Runs_Out=S:\\WOP 15-16\\FY5 Runs - Outputs
    Export_DGs=S:\\WOP 15-16\\Export_DGs
'@}

function New-DGReport {

    $WOPFYRuns = gci $dataTable.FY1Runs_Out -filter "*R2.csv" | select -ExpandProperty FullName
    
    
    $dgColl = @()
    $WOPCount = $WOPFYRuns.count
    $i=1


    foreach ( $csvFile in $WOPFYRuns ) {
    
        if ( $csvFile -match '\d{6}' ) { $lpmodel = $Matches[0] }
        $dgs = Import-Csv -Path $csvFile | where { $_.NodeStatus -match "Known Pressure" }
        foreach ( $k in $dgs ) {
        
            $dgHT = @{
                SYN_LPNodeNumber=$k.NAME
                SYN_Flow=$k.NodeResultFlow
                SYN_Pressure=$k.NodeResultPressure
                SYN_ActiveState=$k.NodeActiveState
                SYN_Description=$k.NodeDescription
                SYN_MinPressure=$k.NodeMinimumPressure
                SYN_Subsystem=$k.NodeSubsystemID
                SYN_Symbol=$k.NodeSymbolName
                SYN_X=$k.NodeXCoordinate
                SYN_Y=$k.NodeYCoordinate
            }
            
            $dgObj = New-Object PSObject -Property $dgHT
            
            $dgColl += $dgObj
            
        }
        Write-Progress -Activity "Collect DGs" -Status "$($lpmodel)" -Id 0 -PercentComplete ($i/$WOPCount * 100)
        $i++
    }
    
    $dgColl | Export-Csv ("$($dataTable.Export_DGs)\FY1_R2_DGs.csv") -NoTypeInformation
    
}
