$dataTable = Data {
    ConvertFrom-StringData @'
    WOP100=C:\\Users\\ac00418\\Documents\\glengyle\\scripts\\rev_iii\\Import-Excel.ps1
    WOP200=C:\\Users\\ac00418\\Documents\\WindowsPowerShell\\FunctionLibrary\\FunctionScripts\\Query-Database.ps1
'@}


function WOP-CompileFunctions
{

    [CmdletBinding()]
    [OutputType([System.Object])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet("Import-Excel","Query-DataBase")]
        [System.String]
        $wopCommand
    )

    $errorLog = @()
    $messageLog = @()

    Try
    {
        switch ($wopCommand)
        {
            'Import-Excel' { $filePath = $dataTable.WOP100; $messageLog += "$($wopCommand) sourced @ $($filePath)" }
            'Query-DataBase' { $filePath = $dataTable.WOP200; $messageLog += "$($wopCommand) sourced @ $($filePath)" }
        }
    }#end Try
    Catch
    {
        $errorLog += "Could not decide command $($wopCommand) in switch [Line 27]"

        break
    }#end Catch

    Try
    {
        # dot source function
        . $filePath
        $messageLog += "Dot source function $($wopCommand)"
    }#end Try dot-source
    Catch
    {
        # Could not dot source function
        $errorLog += "Could not dot source function $($wopCommand) using $($filePath) [Line 48]"
        break
    }#end Catch dot-source

    Try
    {
        # Create return Object
        $messageLog += "Create return object"
        $returnSet = @{
            'WOPCommand'=$wopCommand
            'FilePath'=$filePath
            'ErrorLog'=$errorLog
            'MessageLog'=$messageLog
        }
        $returnObj = New-Object psobject -Property $returnSet
        $returnObj
    }#end Try return object
    Catch
    {
        $errorLog += "Could not create return Object [Line 67]"
        break
    }
}
