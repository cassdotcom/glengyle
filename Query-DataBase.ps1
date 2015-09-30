#region HEADER
###########################################################
# .FILE		: Query-Database.ps1
# .AUTHOR  	: A. Cassidy 
# .DATE    	: 2015-07-01
# .VERSION 	: 1.0
###########################################################
# 
# .CHANGELOG
# Version 1.0 : Initial release
# 
# .INSTRUCTIONS FOR USE
# database_values = Query-Database -database $(database file) -qry $(SQL query)
#
###########################################################
# 
# .CONTENTS
# Interrogates database with query
#
###########################################################
#endregion HEADER

function Query-DataBase
{
	Param(
		# Database name
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]
		$database,
		# Query to database
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]
		$query)

		
	# this holds the results
	$dbase_return = @()
		
    # generic variablkes
	$OpenStatic = 3
	$LockOptimistic = 3
	
	# create connection to database
	$conn = New-Object -ComObject ADODB.Connection
	# create recordset to hold return values
	$rs = New-Object -ComObject ADODB.Recordset
	
	# open connection
	$conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$database")
	
	# query
	$rs.Open($query, $conn, $OpenStatic, $LockOptimistic)
	
    # tests for INSERT rather than SELECT
	if ( ($query.split(" ")[0]) -match "SELECT") {
	
		# read from recordset
		while (!$rs.EOF) {
			$model_info = New-Object PSObject
			foreach ($field in $rs.Fields) {
				$model_info | Add-Member -MemberType NoteProperty -Name $($field.Name) -Value $field.Value
			}
			$rs.MoveNext()
			$dbase_return += $model_info
		}
		
        # close recordset
		$rs.Close()
		
	} else {
	
        # in this case fn inserted into database
		$dbase_return += "Null"
		
	}
	
    # close connection
	$conn.Close()
	
	return $dbase_return
	
}
