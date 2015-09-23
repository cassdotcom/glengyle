WOPTable = Data 
{
ConvertFrom-StringData @'
    SynergeeOutputDirectory_A=S:\\WOP 15-16\\FY1 Runs - Outputs
    SynergeeOutputDirectory_B=S:\\WOP 15-16\\FY5 Runs - Outputs
    SynergeeFileFilter=$($netnum[1])_FY1_R1.csv
    nodeMatchRegex=(\d{1})(\d{5})(\d{8})
    ErrorMsg=Error caught: $($thisError)
'@
}

function MissingNodes
{    
    
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [System.String]
        $nodeNumber
    )
    Try 
    {
    
        $netNum = $nodeNumber -match '(\d{1})(\d{5})(\d{8})' | % { @($Matches[1],($Matches[1]+$Matches[2])) }

        #"Looking for $($nodeNumber) in $($netNum)"

        gci "S:\WOP 15-16\FY1 Runs - Outputs" -filter "$($netnum[1])_FY1_R1.csv" | % { $allNodes = Import-CSV $_.FullName }

        $allNodes | where { $_.NAME -match $nodeNumber } | select NAME, NodeResultFlow, NodePressure,NodeDescription,NodeResultPressure,NodeSubsystemID,NodeSymbolName, NodeStatus,NodeXCoordinate,NodeYCoordinate
        
    }
    Catch
    {
        $thisError = $_
        Write-Host "Error caught: $($thisError)"
        continue
        
    }
    
    
}
