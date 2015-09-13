function Call-WOPGrids {

    try{
      stop-transcript|out-null
    }
    catch [System.InvalidOperationException]{}
    
    $timeNow = Get-Date -UFormat "%Y_%m_%d"
    $tranOut = Join-Path -Path "S:\TEST AREA\ac00418\OpsPlan\log" -ChildPath ($timeNow + "__Call_WOPGridExcel.txt")
        
    Start-Transcript -Path $tranOut -Append
    Write-Host "`n`n`n`n======================================================"
    Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S') CALL-WOPGRIDS.ps1"
    Write-Host "======================================================"

    $SC_grids = gci "V:\T-ASSET\PLANNING\SCOTLAND AND SOUTH VALIDATION\OPS PLAN\OPS PLAN DATA, MODEL RUNS etc\OPS PLAN 2015-16\SCOTLAND\LP MODEL RUNS\"
    
    Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($SC_grids.count) Grid Files detected."
    
    foreach ( $n in $SC_grids ) {
    
        Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t"
        Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t------------------------------------------------------"
        Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t"
        Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($n.basename)"
        
        Open-WOPGridExcel -FilePath $n.fullname -Verbose
        
        Write-Host "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFinished
        
    }
    
    Stop-Transcript
    
}
        
        
