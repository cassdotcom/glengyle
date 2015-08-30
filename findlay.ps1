$msgTable = Data { 

    ConvertFrom-StringData @'
        C_logCreatedFile = C:\\Users\\ac00418\\Documents\\glengyle\\scripts\\rev i\\logCreation.ps1
        C_logPath = C:\\Users\\ac00418\\Documents\\glengyle\\data\\
        S_logPath = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\WOP 15-16\\ModelLogs\\
        S_logCreatedFile = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\scripts\\pshell\\logCreation.ps1
        S_logDeleted = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\scripts\\pshell\\logDeleted.ps1
        S_logRenamed = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\scripts\\pshell\\logRenamed.ps1
        S_logChanged = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\scripts\\pshell\\logChanged.ps1
        startMsg = (Get-Date -UFormat "%Y-%m-%d %T")`tBegin script
        endMsg = (Get-Date -UFormat "%Y-%m-%d %T")`tFinish script
'@
}


function findlay {
<#
    .VERSION
        1.0
#>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [System.String]
        $thisPath,
        [Parameter(Mandatory=$false)]
        [System.String]
        $thisFilt
    )
    
    # Version_0.2

    # path for logs
    if ( $thisPath ) {

        $logPath = $thisPath
        $filter = $thisFilt
        
        # path for created event scriptblock
        $logCreatedFile = $msgTable.C_logCreatedFile

    } else {

        if ( $env:HOMEDRIVE -match "C" ) {

            $logPath = $msgTable.C_logPath
            $filter = "*.csv"

            # path for created event scriptblock
            $logCreatedFile = $msgTable.C_logCreatedFile

        } else {

        
            $logPath = $msgTable.S_logPath
            $filter = "*.csv"

            # path for created event scriptblock
            $logCreatedFile = $msgTable.S_logCreatedFile
            $logDeletedFile = $msgTable.S_logDeleted
            $logChangedFile = $msgTable.S_logChanged
            $logRenamedFile = $msgTable.S_logRenamed

        }
    }


    # create watcher
    $findlay = New-Object System.IO.FileSystemWatcher $logPath, $filter -Property @{
        IncludeSubdirectories = $true
        EnableRaisingEvents = $true
    }

  


    # created event scriptblock
    [ScriptBlock]$logCreated = Get-Command $logCreatedFile | select -ExpandProperty ScriptBlock
    [ScriptBlock]$logDeleted = Get-Command $logDeletedFile | select -ExpandProperty ScriptBlock
    [ScriptBlock]$logRenamed = Get-Command $logRenamedFile | select -ExpandProperty ScriptBlock
    [ScriptBlock]$logChanged = Get-Command $logChangedFile | select -ExpandProperty ScriptBlock



    # action event
    Register-ObjectEvent $findlay "Created" -Action $logCreated

    # action event
    Register-ObjectEvent $findlay "Deleted" -Action $logDeleted

    # action event
    Register-ObjectEvent $findlay "Renamed" -Action $logRenamed

    # action event
    #Register-ObjectEvent $findlay "Changed" -Action $logChanged
    
    Show-Notification -msgText "Log Monitor is now running" -msgTitle "WOP 15/16" -alertLevel info

}
