$msgTable = Data { 

    ConvertFrom-StringData @'
        fy1Run_Output = \\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\WOP 15-16\\FY1 Runs - Outputs\\
        
'@
}

function WOP-Report {

    string sExportFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\WOP 15-16\FY1 Runs - Outputs\602001_FY1_R1.csv"; 
    string sExportFile2 = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\output\602001_FY1_R1.csv";


    # get all run networks from dir
    $runNets = gci $msgTable.fy1Run_Output -Filter "*.csv"

    $FY1Runs = @()

    foreach ( $n in $runNets ) {

        $n -match '(\d{6})_FY1_R(\d{1})'

        $networkFile = @{
            netNumber=$Matches[1]
            runN=$Matches[2]
            baseName=$n.BaseName
            fileAddr=$n.FullName
            fileOwner=($n | Get-Acl).Owner
        }

        $FY1Runs += New-Object -TypeName PSObject -Property $networkFile
        
    } 
    
}
