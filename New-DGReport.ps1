

$dataTable = Data {
ConvertFrom-StringData @'
    FY1Runs_Out=S:\\WOP 15-16\\FY1 Runs - Outputs
    FY5Runs_Out=S:\\WOP 15-16\\FY5 Runs - Outputs
    Export_DGs=S:\\WOP 15-16\\Export_DGs
'@}

function New-DGReport {

    $WOPFY1Runs = gci $dataTable.FY1Runs_Out -filter "*R1.csv" | select -ExpandProperty FullName
    
    
    $dgColl = @()
    $WOPCount = $WOPFY1Runs.count
    $i=1
        
    foreach ( $csvFile in $WOPFY1Runs ) {
    
        if ( $csvFile -match '\d{6}' ) { $lpmodel = $Matches[0] }
        $dgs = import-csv -Path (Join-Path -Path $dataTable.FY1Runs_Out -ChildPath ("$($lpmodel)_FY1_R1.csv")) | where { $_.NodeStatus -match "Known Pressure" }
       
        Write-Progress -Activity "Collect DGs from exports" -Status "$($lpmodel)" -Id 0 -PercentComplete ($i/$WOPCount * 100)
        
        foreach ( $dg in $dgs ) {
        
            $dg | Add-Member -MemberType NoteProperty -Name Run -Value "R1"
            $dg | Add-Member -MemberType NoteProperty -Name Year -Value "FY1"
            
            $dgColl += $dg
            
        }
        
        
        $dgs = import-csv -Path (Join-Path -Path $dataTable.FY1Runs_Out -ChildPath ("$($lpmodel)_FY1_R2.csv")) | where { $_.NodeStatus -match "Known Pressure" }
        
        foreach ( $dg in $dgs ) {
        
            $dg | Add-Member -MemberType NoteProperty -Name Run -Value "R2"
            $dg | Add-Member -MemberType NoteProperty -Name Year -Value "FY1"
            
            $dgColl += $dg
            
        }
        
        $i++
        
    }
    
    <#
        F Y 5
                #>
                
    
    $i=1
    
    $WOPFY5Runs = gci $dataTable.FY5Runs_Out -filter "*.csv" | select -ExpandProperty FullName
    
    $wopCount = $WOPFY5Runs.count
    
    foreach ( $csvFile in $WOPFY5Runs ) {
    
        if ( $csvFile -match '\d{6}' ) { $lpmodel = $Matches[0] }
        $dgs = import-csv -Path (Join-Path -Path $dataTable.FY5Runs_Out -ChildPath ("$($lpmodel)_FY5_R1.csv")) | where { $_.NodeStatus -match "Known Pressure" }
   
        Write-Progress -Activity "Collect DGs from exports" -Status "$($lpmodel)" -Id 0 -PercentComplete ($i/$wopCount * 100)
        
        foreach ( $dg in $dgs ) {
        
            $dg | Add-Member -MemberType NoteProperty -Name Run -Value "R1"
            $dg | Add-Member -MemberType NoteProperty -Name Year -Value "FY5"
            
            $dgColl += $dg
            
        }
        
        
        $dgs = import-csv -Path (Join-Path -Path $dataTable.FY5Runs_Out -ChildPath ("$($lpmodel)_FY5_R2.csv")) | where { $_.NodeStatus -match "Known Pressure" }
        
        foreach ( $dg in $dgs ) {
        
            $dg | Add-Member -MemberType NoteProperty -Name Run -Value "R2"
            $dg | Add-Member -MemberType NoteProperty -Name Year -Value "FY5"
            
            $dgColl += $dg
            
        }
        
        
        $dgs = import-csv -Path (Join-Path -Path $dataTable.FY5Runs_Out -ChildPath ("$($lpmodel)_FY5_R3.csv")) | where { $_.NodeStatus -match "Known Pressure" }
        
        foreach ( $dg in $dgs ) {
        
            $dg | Add-Member -MemberType NoteProperty -Name Run -Value "R3"
            $dg | Add-Member -MemberType NoteProperty -Name Year -Value "FY5"
            
            $dgColl += $dg
            
        }
        $i++
        
    }
    
    
    $dgColl | Export-CSV (Join-Path -Path $dataTable.Export_DGs -ChildPath ("DGs.csv"))
    
}
        
