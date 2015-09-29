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

function Expand-SSFText {

    Param(
        [System.Object]
        $ssf,
        [Switch]
        $ssfFlag
    )

    $ssfFileName = $ssf.FileName
    $ssfAuthor = $ssf.Author
    $ssfDate = $ssf.FileDate
    $ssfEdit = $ssf.Edit
    $ssfFileID = $ssf.FileID
    $ssfComment = $ssf.Comment
    $ssfVersion = $ssf.Version
    $ssfDateAndTime = $ssf.DateAndTime
    $ssfNameOfScript = $ssf.NameOfScript
    $ssfFutureYear = $ssf.FutureYear
    $ssfRun = $ssf.Run
    $ssfOutputFile = $ssf.OutputFile
    $ssfLogFile = $ssf.LogFile
    
    if ( ! ( $ssfFlag ) ) {

$FY1_R1_Text = @"
////////////////////////////////////////////////////////////
// .FILE `t: $ssfFileName
// .AUTHOR `t: $ssfAuthor
// .DATE`t: $ssfDate
// .FILE_ID`t: $ssfFileID
// .VERSION`t: $ssfVersion
////////////////////////////////////////////////////////////
// 
// .NOTES
// This is an automatically generated script, created at
// ${ssfDateAndTime} by $ssfNameOfScript.ps1
//
////////////////////////////////////////////////////////////


int main() 
{ 
   // IMPORT FILES
   // Exchange file - potential switcher
   string sImportFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\input\$ssfRun.csv";
   string sImportFC= "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\exchange\profilesAll.csv";
   // Exchange file settings
   string sImportSettings = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_In.ini"; 
   string sImportSettingsFC = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_Profile.ini"; 
   // Comma separated values
   string sDelimiter = ",";   
   
   // EXPORT FILES
   // Model node data
   string sExportFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\WOP 15-16\$ssfFutureYear Runs - Outputs\$ssfOutputFile.csv"; 
   string sExportFile2 = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\output\$ssfOutputFile.csv";
   // Export settings
   string sExportSettings = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_Ex.ini";
   // No named worksheet
   string sExportWorksheet = "";
   

   // 1. Balance the model
   Analysis.Balance();

   // 2. Turn off all potentials
   Model.ImportExchangeFile(sImportSettings, sImportFile, sDelimiter);
   
   // 3. Turn on all flow categories needed
   Model.ImportExchangeFile(sImportSettingsFC, sImportFC, sDelimiter);

   // 3. Balance
   Analysis.Balance();

   // 4. Find subsystems
   Subsystem.UsePhysicalBorders = true;
   Subsystem.Trace();

   // 5. Export
   Model.ExportExchangeFile(sExportSettings, sExportFile, sExportWorksheet);
   Model.ExportExchangeFile(sExportSettings, sExportFile2, sExportWorksheet);
   
   return 0;
   
 }

"@

    } else { 

    $FY1_R1_Text = @"
////////////////////////////////////////////////////////////
// .FILE `t: $ssfFileName
// .AUTHOR `t: $ssfAuthor
// .DATE `t: $ssfDate
// .FILE_ID `t: $ssfFileID
// .VERSION `t: $ssfVersion
////////////////////////////////////////////////////////////
// 
// .NOTES
// This is an automatically generated script, created at
// ${ssfDateAndTime} by $ssfNameOfScript.ps1
//
////////////////////////////////////////////////////////////


int main() 
{ 
   // IMPORT FILES
   // Exchange file - potential switcher
   string sImportFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\input\$ssfRun.csv";
   string sImportFC= "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\exchange\profilesAll.csv";
   // Exchange file settings
   string sImportSettings = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_In.ini"; 
   string sImportSettingsFC = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_Profile.ini";
   // Comma separated values
   string sDelimiter = ",";   
   
   // EXPORT FILES
   // Model node data
   string sExportFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\WOP 15-16\$ssfFutureYear Runs - Outputs\$ssfOutputFile.csv"; 
   string sExportFile2 = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\output\$ssfOutputFile.csv";
   // Export settings
   string sExportSettings = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\config\WOP15_Ex.ini";
   // No named worksheet
   string sExportWorksheet = "";
   
   // LOG EXPLORER SAVER
   // Options are: General / Analysis / Audit etcc
   string sLogName = "General";
   // Name of saved file
   string sFileName = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\WOP 15-16\ModelLogs\$ssfLogFile.csv";
   // No limit to messages saved
   long nMessageLimit = 0;
   

   // 1. Balance the model
   Analysis.Balance();

   // 2. Turn off all potentials
   Model.ImportExchangeFile(sImportSettings, sImportFile, sDelimiter);
   
   // 3. Turn on all flow categories needed
   Model.ImportExchangeFile(sImportSettingsFC, sImportFC, sDelimiter);

   // 4. Balance
   Analysis.Balance();

   // 5. Find subsystems
   Subsystem.UsePhysicalBorders = true;
   Subsystem.Trace();

   // 6. Export
   Model.ExportExchangeFile(sExportSettings, sExportFile, sExportWorksheet);    
   Model.ExportExchangeFile(sExportSettings, sExportFile2, sExportWorksheet);
   
   // 7. Save log
   System.SendLogToCSV(sLogName, sFileName, nMessageLimit);	
   
   return 0;
   
 }

"@
    }


    $FY1_R1_Text

}

function Create-SSF {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $NetNum
    )
    
    Begin {

        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tBegin Create-SSF function"
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`t========================="

        # 
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tCreate object"
        $ssf = New-Object psobject                                                                                                                                  
        $ssf | Add-Member -MemberType NoteProperty -Name Author -Value "A. CASSIDY"                                                                                                                                           
        $ssf | Add-Member -MemberType NoteProperty -Name FileDate -Value "2015-08-22"                                                                                                                                  
        $ssf | Add-Member -MemberType NoteProperty -Name Comment -Value ""                                                                                                                                    
        $ssf | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"

        $ssf | Add-Member -MemberType NoteProperty -Name LogFile -Value ""

        $DaT = get-date -UFormat "%A, %d %B %Y at %T"                                                                                                                                           
        $ssf | Add-Member -MemberType NoteProperty -Name DateAndTime -Value $DaT
        
        $scriptTitle = $MyInvocation.MyCommand.Name                                                                                                                               
        $ssf | Add-Member -MemberType NoteProperty -Name NameOfScript -Value $scriptTitle          

        $ssf | Add-Member -MemberType NoteProperty -Name FileName -Value ""                                                                                                                                      
        $ssf | Add-Member -MemberType NoteProperty -Name FileID -Value "" 
        $ssf | Add-Member -MemberType NoteProperty -Name FutureYear -Value ""                                                                      
        $ssf | Add-Member -MemberType NoteProperty -Name Run -Value ""    
        $ssf | Add-Member -MemberType NoteProperty -Name OutputFile -Value ""

       

    } Process {

        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tScript is saved in :"
        if ( ! $dbug ) {
            $SaveDir = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\scripts\synergee\autogenerated\" + $NetNum
        } else {
            $SaveDir = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\OpsPlan\scraps\" + $NetNum
        }
        #$SaveDir = "C:\users\ac00418\documents\glengyle\scripts\synergee\autogenerated\" + $NetNum
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`t`t$($SaveDir)"

        if ( ! ( Test-Path $SaveDir ) ) {

            New-Item -Path $SaveDir -ItemType Directory | Out-Null

        }
            
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tBegin processing:`t$($NetNum)"

        $ssf.LogFile = ($NetNum + "_FY1_Analysis_Log")

        # Run 1
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tRun 1"
        $ssf.FileName = "FY1-R1-SSF.ssf"                                                                                                                                      
        $ssf.FileID = ("WOP15F1R1SSF" + $netNum )
        $ssf.FutureYear = "FY1"                                                                      
        $ssf.Run = "R1"           
        $outFile = $NetNum + "_FY1_R1"                                                                                                                                            
        $ssf.OutputFile = $outFile
        Expand-SSFText -ssf $ssf | Out-File ($SaveDir + "\FY1_R1_SSF.txt")



        # Run 2        
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tRun 2"
        $ssf.FileName = "FY1-R2-SSF.ssf"  
        $ssf.FutureYear = "FY1"                                                                                                                                    
        $ssf.FileID = ("WOP15F1R2SSF" + $netNum)                                                                       
        $ssf.Run = "R2"    
        
        $outFile = $NetNum + "_FY1_R2"                                                                                                                                            
        $ssf.OutputFile = $outFile

        Expand-SSFText -ssf $ssf -ssfFlag | Out-File ($SaveDir + "\FY1_R2_SSF.txt")



        # Run 3        
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tRun 3"
        $ssf.FileName = "FY5-R1-SSF.ssf"    
        $ssf.FutureYear = "FY5"                                                                                                                                                 
        $ssf.FileID = ("WOP15F5R1SSF" + $netNum)
        $ssf.Run = "R1"    
        
        $outFile = $NetNum + "_FY5_R1"                                                                                                                                            
        $ssf.OutputFile = $outFile

        Expand-SSFText -ssf $ssf | Out-File ($SaveDir + "\FY5_R1_SSF.txt")



        # Run 4        
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tRun 4"
        $ssf.FileName = "FY5-R2-SSF.ssf"      
        $ssf.FutureYear = "FY5"                                                                                                                                               
        $ssf.FileID = ("WOP15F5R2SSF" + $netNum)
        $ssf.Run = "R2"    
        
        $outFile = $NetNum + "_FY5_R2"                                                                                                                                            
        $ssf.OutputFile = $outFile

        Expand-SSFText -ssf $ssf | Out-File ($SaveDir + "\FY5_R2_SSF.txt")



        # Run 5        
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tRun 5"
        $ssf.FileName = "FY5-R3-SSF.ssf"
        $ssf.FutureYear = "FY5"                                                                                                                                                 
        $ssf.FileID = ("WOP15F5R3SSF" + $netNum)
        $ssf.Run = "R3"    
        
        $outFile = $NetNum + "_FY5_R3"                                                                                                                                            
        $ssf.OutputFile = $outFile

        $ssf.LogFile = ($NetNum + "_FY5_Analysis_Log")

        Expand-SSFText -ssf $ssf -ssfFlag | Out-File ($SaveDir + "\FY5_R3_SSF.txt")
        Write-Verbose "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")]`tEnd processing`t$($NetNum)"

         
    } End {
<#
    .VERSION
        1.2
#> }   
}

