function Show-Notification {
# C:\Users\ac00418\Documents\WindowsPowerShell\FunctionLibrary\FunctionScripts\Show-Notification.ps1
    [CmdletBinding()]
    Param(
        [String]$msgText,
        [String]$msgTitle,
        [ValidateSet("info","warning","error")]
        [String]$alertLevel,
        [Switch]$kill
    )

    #Load the required assemblies
    [void] [System.Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”)
    [void] [System.Reflection.Assembly]::loadwithpartialname("System.Drawing")

    #Remove any registered events related to notifications
    Remove-Event BalloonClicked_event -ea SilentlyContinue
    Unregister-Event -SourceIdentifier BalloonClicked_event -ea silentlycontinue
    Remove-Event BalloonClosed_event -ea SilentlyContinue
    Unregister-Event -SourceIdentifier BalloonClosed_event -ea silentlycontinue
    
    #Create the notification object
    $notification = New-Object System.Windows.Forms.NotifyIcon 
    #Define the icon for the system tray
    switch ($alertLevel) {
        
        'info' { $notification.Icon = [System.Drawing.SystemIcons]::Information }
        'warning' { $notification.Icon = [System.Drawing.SystemIcons]::Warning }
        'error' { $notification.Icon = [System.Drawing.SystemIcons]::Error }

    }

    #Display title of balloon window
    $notification.BalloonTipTitle = $msgTitle

    #Type of balloon icon
    $notification.BalloonTipIcon = $alertLevel

    #Notification message
    $notification.BalloonTipText = $msgText

    #Make balloon tip visible when called
    $notification.Visible = $True

    ## Register a click event with action to take based on event
    #Balloon message clicked
    #register-objectevent $notification BalloonTipClicked BalloonClicked_event -Action {[System.Windows.Forms.MessageBox]::Show(“Balloon message clicked”,”Information”);$notification.Visible = $False;$notification.Dispose()} | Out-Null
    register-objectevent $notification BalloonTipClicked BalloonClicked_event -Action {$notification.Visible = $False;$notification.Dispose()} | Out-Null

    #Balloon message closed
    register-objectevent $notification BalloonTipClosed BalloonClosed_event -Action {$notification.Visible = $False;$notification.Dispose()} | Out-Null

    #Call the balloon notification
    $notification.ShowBalloonTip(600)

    #start-sleep (5)
    #$notification.Visible = $false
    #$notification.Dispose()






    <#
    # Load ballon form
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    if ( $kill ) {
        
        # Kill balloon
        $objNotifyIcon.Dispose()

    } else { 
    
        #if ( $objNotifyIcon -eq $null ) {

            $objNotifyIcon = $null
            $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

        #}

        Switch ( $alertLevel ) {

            'error' { $barIcon = "red"; $msgIcon = "Error" }
            'warning' { $barIcon = "blue"; $msgIcon = "Warning" }
            'info' { $barIcon = "green"; $msgIcon = "Info" }

        }

        $notifyIcon = "C:\Users\ac00418\Documents\WindowsPowerShell\FunctionLibrary\FunctionData\icons\" + $barIcon + ".ico"

        $objNotifyIcon.Icon = $notifyIcon
        $objNotifyIcon.BalloonTipIcon = $msgIcon
        $objNotifyIcon.BalloonTipText = $msgText
        $objNotifyIcon.BalloonTipTitle = $msgTitle
         
        $objNotifyIcon.Visible = $True 
        $objNotifyIcon.ShowBalloonTip(500)

    }
    #>


}


