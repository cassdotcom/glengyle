$msgTable = Data { 

    ConvertFrom-StringData @'
        C_logCreatedFile = C:\\Users\\ac00418\\Documents\\glengyle\\scripts\\rev i\\logCreation.ps1
        C_logPath = C:\\Users\\ac00418\\Documents\\glengyle\\data\\
        S_logPath = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\WOP 15-16\\ModelLogs\\
        S_logCreatedFile = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\scripts\\pshell\\logCreation.ps1
        startMsg = (Get-Date -UFormat "%Y-%m-%d %T")`tBegin script
        endMsg = (Get-Date -UFormat "%Y-%m-%d %T")`tFinish script
'@
}


function findlay {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [System.String]
        $thisPath,
        [Parameter(Mandatory=$false)]
        [System.String]
        $thisFilt
    )

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
            $logCreatedFile = $msgTable.S_logCreated

        }
    }


    # create watcher
    $findlay = New-Object System.IO.FileSystemWatcher $logPath, $filter -Property @{
        IncludeSubdirectories = $true
        EnableRaisingEvents = $true
    }

  


    # created event scriptblock
    [ScriptBlock]$logCreated = Get-Command $logCreatedFile | select -ExpandProperty ScriptBlock



    # action event
    Register-ObjectEvent $findlay "Created" -Action $logCreated

    # action event
    Register-ObjectEvent $findlay "Deleted" -Action $logCreated

    # action event
    Register-ObjectEvent $findlay "Renamed" -Action $logCreated

    # action event
    Register-ObjectEvent $findlay "Changed" -Action $logCreated

}

findlay
