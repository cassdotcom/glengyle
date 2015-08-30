# logDeleted scriptblock.
# this code will be executed when a new log file is created

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

Show-Notification -msgText "$($netNum) $($netYr) DELETED" -msgTitle "WOP15/16" -alertLevel warning
