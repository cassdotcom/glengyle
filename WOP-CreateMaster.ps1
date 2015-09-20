
function WOP-CreateMaster
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [ValidateSet('SO','SE','SC')]
        [System.String]
        $ldz
    )

    Write-Verbose "$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")`tLoad WOP-TeeObject"
    . "C:\Users\ac00418\Documents\glengyle\scripts\rev i\WOP-TeeObject.ps1"
    $outFile = "C:\Users\ac00418\Documents\glengyle\logs\WOP-Matchup.txt"
    Write-Verbose "$(Get-Date -UFormat "%Y-%m-%d %H:%M:%S")`tLog to $($outFile)"

    Try
    {
        $props = @{
            SO="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SO_WOP.xml"
            SE="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SE_WOP.xml"
            SC="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SC_WOP.xml"
        }; $LDZ_WOP = New-Object psobject -Property $props

        $props = @{
            SO="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SO_FY1.xml"
            SE="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SE_FY1.xml"
            SC="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SC_FY1.xml"
        }; $LDZ_FY1 = New-Object psobject -Property $props

        $props = @{
            SO="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SO_FY5.xml"
            SE="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SE_FY5.xml"
            SC="C:\Users\ac00418\Documents\glengyle\data\GRIDS_OBJ\SC_FY5.xml"
        }; $LDZ_FY5 = New-Object psobject -Property $props


        $WOP_DGs = Import-Clixml ( Select-Object -InputObject $LDZ_WOP -Property $ldz | select -ExpandProperty $ldz)
        $FY1_DGs = Import-Clixml ( Select-Object -InputObject $LDZ_FY1 -Property $ldz | select -ExpandProperty $ldz)
        $FY5_DGS = Import-Clixml ( Select-Object -InputObject $LDZ_FY5 -Property $ldz | select -ExpandProperty $ldz)
    }#end Try
    Catch
    {
        $thisError = $_
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tScript FAILURE."
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.Exception.Message)"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.Line.Insert($thisError.InvocationInfo.OffsetInLine, '     <-- THIS CAUSES ISSUE -->     '))"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.PositionMessage)"
        # Need logic here to discern R1 vs R2
	    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY1" $outFile
        Continue
    }#end Catch 


    Try
    {
        $i = 1
        foreach ( $n in $WOP_DGs )
        {
            $n.PSObject.Properties.Remove('FY1_DV')
            $n | Add-Member -MemberType ScriptProperty -Name FY1_DV -Value { $this.FY1_R2_Flow - $this.FY1_R1_Flow }

            $n.PSObject.Properties.Remove('FY5_DV')        
            $n | Add-Member -MemberType ScriptProperty -Name FY5_DV -Value { $this.FY5_R2_Flow - $this.FY5_R1_Flow }
       
            $n.PSObject.Properties.Remove('WOP_FY1Change')        
            $n | Add-Member -MemberType ScriptProperty -Name WOP_FY1Change -Value { $this.FY1_R1_Flow - $this.WOP_ExistingPotentialPeakDemand }

            $n.PSObject.Properties.Remove('WOP_FY1Change_pc')        
            $n | Add-Member -MemberType ScriptProperty -Name WOP_FY1Change_pc -Value { $this.WOP_FY1Change / $this.WOP_ExistingPotentialPeakDemand * 100}

            $n.PSObject.Properties.Remove('WOP_FY1_DP')        
            $n | Add-Member -MemberType ScriptProperty -Name WOP_FY1_DP -Value { $this.FY1_R1_Pressure - $this.WOP_1in20Winter }

            # housecleaning
            $n | Add-Member -MemberType NoteProperty -Name FY1_R1_FailingGTs -Value 0
            $n.PSObject.Properties.Remove("FY1_R1_Failing GTs")

            # Populate FY1
            $theseGovs = $FY1_DGs | where { $_.LPNodeNumber -match $n.WOP_LPNodeNumber }
            if ( $theseGovs.Count -eq 2 )
            {
                $thisGov = $theseGovs | where { $_.NetRun -match 'R1' }

			    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFOUND:`t$($n.WOP_LPNodeNumber)`tFY1`tR1" $outFile
                $n.SYN_UserName = $thisGov.Owner
                $n.SYN_LPNodeNumber = $thisGov.LPNodeNumber
                $n.SYN_Integrated = $thisGov.Subsystemid
                $n.FY1_R1_Flow = $thisGov.Flow
                $n.FY1_R1_Pressure = $thisGov.PressSetting
                $n.FY1_R1_Pmin = $thisGov.Pmin
                $n.FY1_R1_FailingGTs = $thisGov.FailingGTs

                $thatGov = $theseGovs | where { $_.NetRun -match 'R2' }

			    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFOUND:`t$($n.WOP_LPNodeNumber)`tFY1`tR2" $outFile
                $n.FY1_R2_Flow = $thatGov.Flow
                $n.FY1_R2_Pmin = $thatGov.Pmin
                $n.FY1_R2_FailingGTs = $thatGov.FailingGTs
                
                # Clean up
                foreach ( $dun in @('theseGovs', 'thisGov', 'thatGov') )
                {
                    Remove-Variable -Name $dun
                }

            }
            else
            {
                # Need logic here to discern R1 vs R2
			    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY1" $outFile
            }


            # Populate FY5
            $theseGovs = $FY5_DGs | where { $_.LPNodeNumber -match $n.WOP_LPNodeNumber }
            if ( $theseGovs.Count -eq 3 )
            {
                if ( $thisGov = $theseGovs | where { $_.NetRun -match 'R1' } )
                {
			        WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFOUND:`t$($n.WOP_LPNodeNumber)`tFY5`tR1" $outFile
                    $n.FY5_R1_Flow = $thisGov.Flow
                    $n.FY5_R1_Pressure = $thisGov.PressSetting
                    $n.FY5_R1_Pmin = $thisGov.Pmin
                    $n.FY5_R1_FailingGTs = $thisGov.FailingGTs
                } else { WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY5`tR1" $outFile }

                if ( $thatGov = $theseGovs | where { $_.NetRun -match 'R2' } )
                {
                    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFOUND:`t$($n.WOP_LPNodeNumber)`tFY5`tR2" $outFile
                    $n.FY5_R2_Flow = $thatGov.Flow
                    $n.FY5_R2_Pmin = $thatGov.Pmin
                    $n.FY5_R2_FailingGTs = $thatGov.FailingGTs
                } else { WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY5`tR2" $outFile }

                if ( $thatGov = $theseGovs | Where { $_.NetRun -match 'R3' } )
                {
                    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tFOUND:`t$($n.WOP_LPNodeNumber)`tFY5`tR2" $outFile
                    $n.FY5_R3_Flow = $thatGov.Flow
                } else { WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY5`tR3" $outFile }
                
                # Clean up
                foreach ( $dun in @('theseGovs', 'thisGov', 'thatGov') )
                {
                    Remove-Variable -Name $dun
                }

            }
            else
            {
                # Need logic here to discern R1 vs R2
			    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY5" $outFile
            }

            Write-Progress -Activity "Match DGs" -CurrentOperation "$($n.WOP_Name)" -PercentComplete ($i/$WOP_DGs.Count * 100)
            $i++

        }#end foreach

    }#end Try

    Catch
    {
        $thisError = $_
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tScript FAILURE."
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.Exception.Message)"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.Line.Insert($thisError.InvocationInfo.OffsetInLine, '     <-- THIS CAUSES ISSUE -->     '))"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.PositionMessage)"
        # Need logic here to discern R1 vs R2
	    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY1" $outFile
    }#end Catch
    

    Try
    {
        $WOP_DGs | Export-Clixml "C:\Users\ac00418\Documents\glengyle\data\MATCHUP\WOP_DG_$($ldz).xml"
	    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`Write WOP DGs to file." $outFile
    }

    Catch
    {
        $thisError = $_
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tScript FAILURE."
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.Exception.Message)"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.Line.Insert($thisError.InvocationInfo.OffsetInLine, '     <-- THIS CAUSES ISSUE -->     '))"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t"
        Write-Verbose "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`t$($thisError.InvocationInfo.PositionMessage)"
        # Need logic here to discern R1 vs R2
	    WOP-TeeObject "$(Get-Date -UFormat '%Y/%m/%d %H:%M:%S')`tMISSING:`t$($n.WOP_LPNodeNumber)`tFY1" $outFile
    }
	
}
		
		
		
	
