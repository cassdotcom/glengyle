$msgTable = Data { 
	ConvertFrom-StringData @'
		outputDir=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\output\\
        LCSQuery=SELECT * FROM LCSDetail
'@}
<#
.Synopsis
   Short description
.VERSION
    1.0
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function WOP-DetectScripts {

    Param(
        [System.Object]
        $wopObj,
        [System.String]
        $wopYr
    )

    $missingScripts = @()

    foreach ( $n in $wopObj ) {

        $database = $n.FY1
		$run1 = $msgTable.outputDir + $n.NUMBER + "_" + $wopYr + "_R1.csv"
        $qry = $msgTable.LCSQuery

        $scripts = Query-DataBase -database $database -query $qry

        if ( $scripts.Count -ne 2 ) {

            $missingScripts += $n
            Write-Verbose "Missing`t$n.TITLE" }
			
	}
		
}
