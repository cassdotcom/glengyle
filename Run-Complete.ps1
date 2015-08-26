
function findlay {
    # watchdog - function FINDLAY


    # LOC killer - function NEESON

    <#
    # path for logs
    $logPath = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\WOP 15-16\ModelLogs\"
    $filter = "*.csv"

    # path for created event scriptblock
    $logCreatedFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\scripts\pshell\logCreation.ps1"
    #>


    # path for logs
    $logPath = "C:\Users\ac00418\Documents\glengyle\data\"
    $filter = "*.csv"

    # path for created event scriptblock
    $logCreatedFile = "C:\Users\ac00418\Documents\glengyle\scripts\rev i\logCreation.ps1"



    # create watcher
    $findlay = New-Object System.IO.FileSystemWatcher $logPath, $filter -Property @{
        IncludeSubdirectories = $false
        EnableRaisingEvents = $true
    }


    # created event scriptblock
    [ScriptBlock]$logCreated = Get-Command $logCreatedFile | select -ExpandProperty ScriptBlock
    #Write-Host $logCreated



    # action event
    Register-ObjectEvent $findlay "Created" -Action $logCreated

}
