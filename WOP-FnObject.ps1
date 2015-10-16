<#
.Synopsis
   Short description
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

$dataTable = Data {
ConvertFrom-StringData @'
    fnHeader=C:\\Users\\ac00418\\Documents\\glengyle\\config\\ps1\\header.ps1
    WOP_dll=C:\\Users\\ac00418\\Documents\\glengyle\\dll\\WOP_1516_DLL.accdb
'@
}

function WOP-FnObject
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    Param()

    DynamicParam
    { 
    <# 

        WOP Function parameter
        ----------------------

    #>
        # If there's no fnLibrary, quit
        if ( ! ( Test-Path $dataTable.WOP_dll ) )
        {
            Throw 'Function libray does not exist'
        }#end if

        $parameterName = 'WOPFunction'

        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $AttributeCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]'

        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 0
        $ParameterAttribute.HelpMessage = "Select function from WOP library"

        $AttributeCollection.Add($ParameterAttribute)

        Try
        {
            # Generate valid function names
            $query = "SELECT FUNCTIONNAME FROM VersionControl"

            $connectionStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + $dataTable.WOP_dll + ";"
            # Create connection
            $connection = New-Object System.Data.OleDb.OleDbConnection($connectionStr)
            $connection.Open()

            # Query
            $cmd = New-Object System.Data.OleDb.OleDbCommand($query,$connection)
            # Create data adapter
            $da = New-Object System.Data.OleDb.OleDbDataAdapter($cmd)
            # Return object, and fill
            $dt = New-Object System.Data.DataTable
            [void]$da.Fill($dt)

            # Close connection
            $connection.Close()
        }#end Try
        Catch
        {
            Throw 'Failed to connect to database'
        }


        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($dt.FUNCTIONNAME)

        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($parameterName, [String], $AttributeCollection)
        $RuntimeParameterDictionary.Add($parameterName, $RuntimeParameter)

        <# 

            WOP Function parameter
            ----------------------

        #>

        return $RuntimeParameterDictionary
    }

    Begin
    {
        $WOPFunction = $PSBoundParameters[$parameterName]            
    }#end Begin

    Process
    {
        Write-Verbose "$($WOPFunction) chosen"
        Try
        {
            # Connnect to DB and update:
            $tbl = "Fn" + $WOPFunction.Replace("-","")
            $query = "SELECT TOP 1 * FROM $($tbl) ORDER BY ID DESC"

            $connectionStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + $dataTable.WOP_dll + ";"
            # Create connection
            $connection = New-Object System.Data.OleDb.OleDbConnection($connectionStr)
            $connection.Open()

            # Query
            $cmd = New-Object System.Data.OleDb.OleDbCommand($query,$connection)
            # Create data adapter
            $da = New-Object System.Data.OleDb.OleDbDataAdapter($cmd)
            # Return object, and fill
            $fnData = New-Object System.Data.DataTable
            [void]$da.Fill($fnData)

            # Close connection
            $connection.Close()
        }
        Catch
        {
            Write-Error "Could not pull db"
            Throw "Encountered Error:`n`t$($_)"
        }

        Write-verbose "$($fnData.FUNCTIONID)"

        $qry = "INSERT INTO FnCreateSSF (FUNCTIONID,
                                            TITLE,
                                            REVISION,
                                            PATH,
                                            DESCRIPTION,
                                            REVISIONDATE,
                                            FILEID,
                                            FILEHASH,
                                            FUNCTIONOWNER,
                                            FUNCTIONAUTHOR,
                                            SYNOPSIS,
                                            FILENAME,
                                            COMMENT,
                                            INPUTNUMBER,
                                            INPUTNAMES,
                                            INPUTDESCRIPTION,
                                            OUTPUTNUMBER,
                                            OUTPUTNAMES,
                                            OUTPUTDESCRIPTION,
                                            NOTESREVISION,
                                            EXAMPLECOUNT,
                                            EXAMPLEDESCRIPTION,
                                            FUNCTIONTEXT)
                    VALUES ($fnData.FUNCTIONID,
                            $fnData.TITLE,
                            $fnData.REVISION,
                            $fnData.PATH,
                            $fnData.DESCRIPTION,
                            $fnData.REVISIONDATE,
                            $fnData.FILEID,
                            $fnData.FILEHASH,
                            $fnData.FUNCTIONOWNER,
                            $fnData.FUNCTIONAUTHOR,
                            $fnData.SYNOPSIS,
                            $fnData.FILENAME,
                            $fnData.COMMENT,
                            $fnData.INPUTNUMBER,
                            $fnData.INPUTNAMES,
                            $fnData.INPUTDESCRIPTION,
                            $fnData.OUTPUTNUMBER,
                            $fnData.OUTPUTNAMES,
                            $fnData.OUTPUTDESCRIPTION,
                            $fnData.NOTESREVISION,
                            $fnData.EXAMPLECOUNT,
                            $fnData.EXAMPLEDESCRIPTION,
                            $fnData.FUNCTIONTEXT) "



    }
    End
    {
    }
}
