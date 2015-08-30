function Update-Database {

    Param(
        [Parameter(Position = 0, Mandatory = $true)]
		[System.String]
		$database,
        # Query to database
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]
		$query
    )
    
    # generic variablkes
	$OpenStatic = 3
	$LockOptimistic = 3
	
	# create connection to database
	$conn = New-Object -ComObject ADODB.Connection
	# create recordset to hold return values
	$rs = New-Object -ComObject ADODB.Recordset
	
	# open connection
	$conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$database")
    $rs.Open($qry, $conn, $OpenStatic, $LockOptimistic)
    
    #$rs.Close()
    $conn.Close()
    
}
    
