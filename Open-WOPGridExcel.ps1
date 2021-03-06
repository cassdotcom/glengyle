$dataTable = Data {
ConvertFrom-StringData @'
    thisRev=2
    savePath=C:\\Users\\ac00418\\Documents\\glengyle\\logs
    SO_GRIDS=C:\\Users\\ac00418\\Documents\\glengyle\\data\\GRIDS_XLSX\\SOUTH\\LP MODEL RUNS
    SE_GRIDS=C:\\Users\\ac00418\\Documents\\glengyle\\data\\GRIDS_XLSX\\SOUTH EAST\\LP MODEL RUNS
'@}
function Open-WOPGridExcel {

	[CmdletBinding()]
	param (
        [ValidateNotNullOrEmpty()]
        [ValidateScript({(Test-Path $_)})]
        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]
        [System.String]$FilePath,
        [Parameter(Mandatory = $false)]
        [System.String]$fileOut        
    )

    #WOP-TeeObject "This is Revision: $($dataTable.thisRev)"
    
    # create excel s/s
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tCreate excel s/s" $fileOut
	$xl = New-Object -ComObject Excel.Application
	# hide
	$xl.Visible = $false
	# don't bring up warnings
	$xl.DisplayAlerts = $false
    
    # open workbook
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tOpen workbook" $fileOut
	$wb = $xl.Workbooks.Open($filepath)
	$ws = $wb.Worksheets.Item(1)
	$ws.Activate()
    
    # find end of s/s
	$lastRow = $ws.UsedRange.Rows.Count
	$lastCol = $ws.UsedRange.Columns.Count
	
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($lastRow) Rows" $fileOut
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($lastCol) Columns" $fileOut
    
    # ignore headers
	$thisRow = 3

	# number of DGs
	$govcount = $lastRow - $thisRow
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($govcount) DGs in grid" $fileOut

	# counter
	$dg_dataArr = @()


    for ( $k=$thisRow;$k -lt ($lastRow); $k++ ) {

		$dg_data = @{}
		
		WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tRow $($k)" $fileOut

		$dg_data.add('WOP_EquipmentID',$ws.Cells.Item($k,1).value())
		$dg_data.add('WOP_GridNumber',$ws.Cells.Item($k,2).value())
		$dg_data.add('WOP_Area',$ws.Cells.Item($k,3).value())
		$dg_data.add('WOP_Name',$ws.Cells.Item($k,4).value())
		$dg_data.add('WOP_LPModel',$ws.Cells.Item($k,5).value())
		$dg_data.add('WOP_TypeOfEquipment',$ws.Cells.Item($k,6).value())
		$dg_data.add('WOP_Location',$ws.Cells.Item($k,7).value())
		$dg_data.add('WOP_Town',$ws.Cells.Item($k,8).value())
		$dg_data.add('WOP_Integrated',$ws.Cells.Item($k,9).value())
		$dg_data.add('WOP_LPNodeNumber',$ws.Cells.Item($k,10).value())
		$dg_data.add('WOP_MPNodeNumber',$ws.Cells.Item($k,11).value())
		$dg_data.add('WOP_XCoOrdinate',$ws.Cells.Item($k,12).value())
		$dg_data.add('WOP_YCoOrdinate',$ws.Cells.Item($k,13).value())
		$dg_data.add('WOP_1in20Winter',$ws.Cells.Item($k,14).value())
		$dg_data.add('WOP_ExistingPotentialPeakDemand',$ws.Cells.Item($k,15).value())

		$dg_dataObj = New-Object PSObject -Property $dg_data
		$dg_dataArr += $dg_dataObj
		
	}
    
    <#
    $dg_dataDG = $dg_dataArr | where { $_.WOP_TypeOfEquipment -match 'DG' }
    $dg_dataRRI = $dg_dataArr | where {$_.WOP_TypeOfEquipment -match 'RRI' }
    
    $dg_dataCLEAN = [array]$dg_dataDG + $dg_dataRRI
    #>
    
    #WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tRemoved $($dg_dataArr.Count - $dg_dataCLEAN.Count) empty entries." $fileOut

    $newXML = (Split-Path $filepath -Leaf).replace(".xlsx",".xml")
    $outFile = Join-Path -Path "C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ" -ChildPath $newXML
    
    $dg_dataArr | Export-Clixml $outFile
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tExported to xml [$($outFile)]" $fileOut
	WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tClosing Excel" $fileOut
    $wb.Close()
    $xl.Quit()
    
}
