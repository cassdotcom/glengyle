# DG-Extractor.ps1
# This file will extract governor data when given a model path.

function DG-Extractor {
 <#
    .Synopsis
        Gets the content of an INI file
    .Description
        Gets the content of an INI file and returns it as a hashtable
    .Notes
        Author		: Oliver Lipkau <oliver@lipkau.net>
		Source		: https://github.com/lipkau/PsIni
                      http://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91
        Version		: 1.0.0 - 2010/03/12 - OL - Initial release
                      1.0.1 - 2014/12/11 - OL - Typo (Thx SLDR)
                                              Typo (Thx Dave Stiff)
                      1.0.2 - 2015/06/06 - OL - Improvment to switch (Thx Tallandtree)
                      1.0.3 - 2015/06/18 - OL - Migrate to semantic versioning (GitHub issue#4)
                      1.0.4 - 2015/06/18 - OL - Remove check for .ini extension (GitHub Issue#6)
                      1.1.0 - 2015/07/14 - CB - Improve round-tripping and be a bit more liberal (GitHub Pull #7)
                                           OL - Small Improvments and cleanup
                      1.1.1 - 2015/07/14 - CB - changed .outputs section to be OrderedDictionary
        #Requires -Version 2.0
    .Inputs
        System.String
    .Outputs
        System.Collections.Specialized.OrderedDictionary
    .Parameter FilePath
        Specifies the path to the input file.
    .Parameter CommentChar
        Specify what characters should be describe a comment.
        Lines starting with the characters provided will be rendered as comments.
        Default: ";"
    .Parameter IgnoreComments
        Remove lines determined to be comments from the resulting dictionary.
         
    .Example
        $FileContent = Get-IniContent "C:\myinifile.ini"
        -----------
        Description
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent
    .Example
        $inifilepath | $FileContent = Get-IniContent
        -----------
        Description
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent
    .Example
        C:\PS>$FileContent = Get-IniContent "c:\settings.ini"
        C:\PS>$FileContent["Section"]["Key"]
        -----------
        Description
        Returns the key "Key" of the section "Section" from the C:\settings.ini file
    .Link
        Out-IniFile
    #>

    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateScript({(Test-Path $_)})]
        [System.String]
        $model
    )


    Try {

        # pull nodes from db
        $qry = "SELECT GasNodeControl.NodeId
                FROM GasNodeControl
                WHERE GasNodeControl.IsKnownPressure"

        Write-Verbose "Use query: $($qry)"

        # Call db
        $DGNodes = Query-DataBase -database $model -qry $qry

        # Test for null return
        $DGCount = $DGNodes.Count
        Write-Verbose "$($DGCount) DGs found"

        if ( $DGCount = 0 ) { Write-Warning "No DGs found. Script will now exit."; return }

    } Catch {

        $thisError = $_
        Write-Error "$($thisError)`nError in DG call. Script will now exit."
        return

    }


    Try {

        $modelDGs = @()

        # Pull from db
        foreach ( $n in $DGNodes ) {

            $DG = @{'NodeID'=$n.NodeId}

            # Flow data
            $DG.Add('Flow',(Query-DataBase -database $model -qry "SELECT Flow FROM GasNodeDemand WHERE NodeId=$($n.NodeId)").Flow)
            $DG.Add('Description',(Query-DataBase -database $model -qry "SELECT Description FROM NodeDescriptions WHERE NodeId=$($n.NodeId)").Description)
            $DG.Add('Pressure',(Query-DataBase -database $model -qry "SELECT Pressure FROM GasNode WHERE NodeId=$($n.NodeId)").Pressure)
            $DG.Add('NodeNumber',(Query-DataBase -database $model -qry "SELECT StringVal FROM NodeNameIdMap WHERE IdVal=$($n.NodeId)").StringVal)

            $modelDG = New-Object -TypeName PSObject -Property $DG

            $modelDGs += $modelDG
            Write-Verbose "$($modelDG.Description)"

        }

    } Catch {

        $thisError = $_
        Write-Error "$($thisError)`nError in node data construction. Script will now exit."
        return

    }

    $modelDGs

}
