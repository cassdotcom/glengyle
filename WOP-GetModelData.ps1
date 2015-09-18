
function WOP-GetModelData {

    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_.FullName})]
        $synExport
        

    # get FY1Runs output contents
    #$SC_LP = Import-Clixml "\\scotia.sgngroup.net\dfs\Shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\data\all_SC_LP.xml"
    #$netnumbers = $SC_LP | select -Property NUMBER
    $fy1Runs = gci "\\scotia.sgngroup.net\dfs\Shared\Syn4.2.3\WOP 15-16\FY1 Runs - Outputs\" -Filter "*.csv"

    # Object collector
    $modelDataCollColl = @()
    # Loop through
    foreach ( $n in $fy1Runs ) 
    {

        if ( $n.basename -match  '(\d{6})_(FY\d{1})_(R\d{1})' ) 
        { 
            $NetNumber = $Matches[1]
            $NetYear = $Matches[2]
            $NetRun = $Matches[3] 
        }
        else 
        {
            $NetNumber = "000000"
            $NetYear = "FYX"
            $NetRun = "RX" 
        }
            
        # Import Synergee out file
        $nodes = (Import-Csv $n.fullname)
        
        #DGs
        $dgs =  $nodes | where { $_.NodeStatus -match "Known Pressure" }
            
        # Minimum pressures
        $pmin = ($nodes | sort -Property NodeResultPressure)[0]
        
        # Gts 
        $gt = $nodes | where { ($_.NodeSymbolName -match 'CSEP DDS Matched') -or ($_.NodeSymbolName -match 'CSEP Unmatched') }
        
        $failingGT = $gt | where { $_.NodeResultPressure -lt $_.NodeMinimumPressure}
        if ( $failingGT.length -le 0 ) { 
            $failingGTCount = 0 }
        else {
            $failingGTCount = $failingGT.Count }
        
        # Model failing?
        if ( ($pmin.NodeResultPressure -lt 21 ) -or ( $failingGT.Count -gt 0 ) ) { 
            $modelFail="YES" } 
        else { 
            $modelFail="NO" }
        
        Write-host "$($NetNumber)`t$($dgs.count) DG"

        # Local object (DG) collector
        $modelDataColl = @()
        foreach ( $m in $dgs ) {
        
            $modelData = @{
                'Number' = $NetNumber
                'NetYear' = $NetYear
                'NetRun' = $NetRun
                'Owner' = ((Get-Acl $n.FullName).owner).Replace("SCOTIA\","")
                'SubSystemID' = $m.NodeSubsystemID
                'LPNodeNumber' = $m.NAME
                'PressSetting' = $m.NodeResultPressure
                'Pmin' = $pmin.NodeResultPressure
                'Flow' = $m.NodeResultFlow
                'FailingGTs' = $failingGTCount
                'ModelFail'=$modelFail
            }
                
            $modelDataObj = New-Object -TypeName PSObject -Property $modelData
            $modelDataColl += $modelDataObj
            
        }# end foreach
        
        $modelDataCollColl += $modelDataColl

    }#end foreach ( $n in $fy1Runs )

    $modelDataCollColl
    <#
        .VERSION
        1.1
    #>
}
    
            
