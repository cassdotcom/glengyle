# logCreation scriptblock.
# this code will be executed when a new log file is created

$MASTER_DG_DATA = "S:\TEST AREA\ac00418\OpsPlan\output\MasterDGData.xml"
$WOPLog = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\WOPLog.txt"

$path = $Event.SourceEventArgs.FullPath
$name = $Event.SourceEventArgs.Name
$changeType = $Event.SourceEventArgs.Changetype
$timestamp = $Event.TimeGenerated

if ($name -match '\d{6}') { $netNum = $Matches[0] } else { $netNum = "000000" }
if ($name -match 'FY\d{1}') { $netYr = $Matches[0] } else { $netYr = "FY0" }


$logDirEvent = "$($timestamp),$($changeType),$($netNum),$($netYr),$($name)"
$logDirEventPath = $path


"$($logDirEvent)" | Out-File $WOPLog -Append

Show-Notification -msgText "$($netNum) $($netYr) COMPLETE" -msgTitle "WOP15/16" -alertLevel info

# Get dgs
$dgs = Update-DGSS -netNumber $netNum -netYear $netYr[2]
# Load script output
$outFile1 = import-csv "S:\TEST AREA\ac00418\OpsPlan\output\$($netNum)_$($netYr)_R1.csv"
# Load master s/s
$dgFile = Import-Clixml $MASTER_DG_DATA


# Add dg data to s/s
foreach ( $dg in $dgs ) { 

    $dgFile += ( $outFile1 | where { $_.NAME -match $dg } )
    
}

Remove-Item -Path $MASTER_DG_DATA
$dgFile | Export-Clixml $MASTER_DG_DATA -NoClobber

Show-Notification -msgText "Master List updated" -msgTitle "WOP 15/16" -alertLevel info

"$($timestamp)`t$($netNum)  $($netYr)  ADDED TO MASTER DG LIST" | Out-File $WOPLog -Append
