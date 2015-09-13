function Call-WOPGrids {
    
    $timeNow = Get-Date -UFormat "%Y_%m_%d"
    $tranOut = Join-Path -Path "S:\TEST AREA\ac00418\OpsPlan\log" -ChildPath ($timeNow + "__Call_WOPGridExcel.txt")

    $msg = @"
======================================================
$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S') CALL-WOPGRIDS.ps1
======================================================
"@ | Tee-Object $tranOut

    $SC_grids = gci "V:\T-ASSET\PLANNING\SCOTLAND AND SOUTH VALIDATION\OPS PLAN\OPS PLAN DATA, MODEL RUNS etc\OPS PLAN 2015-16\SCOTLAND\LP MODEL RUNS\"
    
    "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($SC_grids.count) Grid Files detected." | Tee-Object $tranOut
    
    foreach ( $n in $SC_grids ) {
    
        "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t" | Tee-Object $tranOut
        "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t------------------------------------------------------" | Tee-Object $tranOut
        "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t" | Tee-Object $tranOut
        "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($n.basename)" | Tee-Object $tranOut
        
        Open-WOPGridExcel -FilePath $n.fullname -fileOut $tranOut
        
        "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFinished" | Tee-Object $tranOut
        
    }
    
    
}
        
        
    
        
