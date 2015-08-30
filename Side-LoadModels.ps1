
function Side-LoadModels { 

    Param($netNumbers, $modelList)
    
    $i = 0

    foreach ( $n in $netNumbers ) {


        $workObject = $modelList | where { $_.NUMBER -match $n }
        #$model = "S:\WOP 15-16\N1\" + (split-path $workObject.FY1MOD -Leaf)
        $model = $workObject.PATH
        
        Write-Progress -Activity "Sideload models" -Status "$($workObject.TITLE)" -PercentComplete ($i/($netNumbers.Count)*100)

        
        $scriptText = gc ("S:\TEST AREA\ac00418\OpsPlan\scripts\synergee\autogenerated\" + $workObject.NUMBER + "\FY1_R1_SSF.txt") | Out-string
        $scriptName = "FY1_R1_SSF"
        
        Update-ScriptTable -model $model -scriptText $scriptText -scriptName $scriptName -scripDescrip "Run 1"
        
        $scriptText = gc ("S:\TEST AREA\ac00418\OpsPlan\scripts\synergee\autogenerated\" + $workObject.NUMBER + "\FY1_R2_SSF.txt") | Out-String
        $scriptName = "FY1_R2_SSF"
        
        Update-ScriptTable -model $model -scriptText $scriptText -scriptName $scriptName -scripDescrip "Run 2"
        
        start-sleep(1)
        $i++

    }


}
