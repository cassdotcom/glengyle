$msgTable = Data { 
	ConvertFrom-StringData @'
		outputDir=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\OpsPlan\\output\\
        LCSQuery=SELECT * FROM LCSDetail
		Run1=_R1.csv
		Run2=_R2.csv
		Run3=_R3.csv
		StartScriptMsg=[$(Get-Date -UFormat "%Y-%m-%d %T")]`tBegin script
		EndScript=[$(Get-Date -UFormat "%Y-%m-%d %T")]`tEnd script
'@
}
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

	[CmdletBinding()]
    Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [System.Object]
        $wopObj
    ) #end Param 
	
	Begin {
	
		Write-Verbose $msgTable.StartScriptMsg
		$qry = $msgTable.LCSQuery 
		Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`tQuery: $($qry)"
		$script:missingNets = @()
		$script:foundNets = @()
		
	} #end _BEGIN
	
	Process {
	
		# Database is model mdb		
		# Pull db
		Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`t$($wopObj.TITLE)"
        
        # fy1
        Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`tYear: 1"
        $wopYr = "FY1"
        $scriptCount = 2
		$scripts = Query-DataBase -database ($wopObj.FY1) -query $qry

		if ( $scripts.Count -ne $scriptCount ) {

			Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`tMissing`t$n.NUMBER"
			$script:missingNets += "$($wopObj.ID), 1"  }
			
		else { 

			$script:foundNets += "$($wopObj.ID), 1"  }
            
        # fy5
        Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`tYear: 5"
        $wopYr = "FY5"
        $scriptCount = 3
		$scripts = Query-DataBase -database ($wopObj.FY5) -query $qry

		if ( $scripts.Count -ne $scriptCount ) {

			Write-Verbose "[$(Get-Date -UFormat "%Y-%m-%d %T")]`tMissing`t$n.NUMBER"
			$script:missingNets += "$($wopObj.ID), 5" }
			
		else { 

			$script:foundNets += "$($wopObj.ID), 5"  }
			
	} #end Process
	
	End {
	
		$script:foundNets | Export-Clixml "S:\TEST AREA\ac00418\OpsPlan\data\FoundNets.xml" -NoClobber
		$script:missingNets | Export-Clixml "S:\TEST AREA\ac00418\OpsPlan\data\MissingNets.cml" -NoClobber
		
		Write-Host "There were $(($script:foundNets).count) networks FOUND." -ForegroundColor DarkGreen
		Write-Host "There were $(($script:missingNets).count) networks MISSING." -ForegroundColor DarkRed
		
	} #end END
			
} 
