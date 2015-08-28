function Show-Notification {

    [CmdletBinding()]
    Param(
        [String]$msgText,
        [String]$msgTitle,
        [ValidateSet("info","warning","error")]
        [String]$alertLevel,
        [Switch]$kill
    )

    
    # Load ballon form
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    if ( $kill ) {
        
        # Kill balloon
        $script:objNotifyIcon.Dispose()

    } else { 
    
        #if ( $script:objNotifyIcon -eq $null ) {

            $script:objNotifyIcon = $null
            $script:objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

        #}

        Switch ( $alertLevel ) {

            'error' { $barIcon = "red"; $msgIcon = "Error" }
            'warning' { $barIcon = "blue"; $msgIcon = "Warning" }
            'info' { $barIcon = "green"; $msgIcon = "Info" }

        }

        $notifyIcon = "C:\Users\ac00418\Documents\WindowsPowerShell\FunctionLibrary\FunctionData\icons\" + $barIcon + ".ico"

        $script:objNotifyIcon.Icon = $notifyIcon
        $script:objNotifyIcon.BalloonTipIcon = $msgIcon
        $script:objNotifyIcon.BalloonTipText = $msgText
        $script:objNotifyIcon.BalloonTipTitle = $msgTitle
         
        $script:objNotifyIcon.Visible = $True 
        $script:objNotifyIcon.ShowBalloonTip(500)

    }
}


