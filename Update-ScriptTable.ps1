
function Update-ScriptTable {

    Param(
        [System.String]
        $model,
        [System.String]
        $scriptText,
        [System.String]
        $scriptName,
        [System.String]
        $scripDescrip
    )


    # db variables
    $OpenStatic = 3
    $LockOptimistic = 3
	
    # create connection to database
    $conn = New-Object -ComObject ADODB.Connection
    # create recordset to hold return values
    $rs = New-Object -ComObject ADODB.Recordset


    #$counts = 0




    #region LCSDetail
    $qry = "SELECT * FROM LCSDetail"
    $conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$model")
    $rs.Open($qry, $conn, $OpenStatic, $LockOptimistic)

    <#while (!$rs.EOF) {

        $counts = $rs.Fields.Value
        $rs.MoveNext()
    
    }#>
    
    $newScriptID = ($rs.RecordCount + 1)

    #$newScriptId = $counts + 1
    $rs.AddNew()

    $rs.Fields.Item("ScriptId").Value=$newScriptID
    $rs.Fields.Item("Description").Value=$scripDescrip
    $rs.Fields.Item("ScriptNumber").Value=$newScriptID
    $rs.Fields.Item("IsActive").Value=$true
    $rs.Fields.Item("TypeId").Value=0

    $rs.Update()
    $rs.Close()
    #endregion LCSDetail



    #region LCSItem
    $qry = "SELECT * FROM LCSItem"
    #$conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$model")
    $rs.Open($qry, $conn, $OpenStatic, $LockOptimistic)

    $rs.AddNew()
    $rs.Fields.Item("ScriptId").Value=$newScriptID 
    $rs.Fields.Item("Sequence").Value=1
    $rs.Fields.Item("Script").Value=$scriptText
    $rs.Update()

    $rs.Close()
    #endregion LCSItem



    #region LCSNameIdMap
    $qry = "SELECT * FROM LCSNameIdMap"
    #$conn.Open("Provider = Microsoft.Jet.OLEDB.4.0;Data Source=$model")
    $rs.Open($qry, $conn, $OpenStatic, $LockOptimistic)

    $rs.AddNew()
    $rs.Fields.Item("IdVal").Value=$newScriptID
    $rs.Fields.Item("StringVal").Value=$scriptName
    $rs.Update()
    
    $rs.Close()

    $conn.Close()
    #endregion LCSNameIdMap
    
    

}




