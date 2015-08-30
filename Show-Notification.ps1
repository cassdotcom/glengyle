function Show-Notification {

# C:\Users\ac00418\Documents\WindowsPowerShell\FunctionLibrary\FunctionScripts\Show-Notification.ps1

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [String]$msgText,
        [String]$msgTitle,
        [ValidateSet("info","warning","error")]
        [String]$alertLevel,
        [Int]$Timeout = 10000
    )

    Add-Type -AssemblyName System.Windows.Forms

    if ($script:balloon -eq $null) {
        $script:balloon = New-Object System.Windows.Forms.NotifyIcon
    }

    $balloon.Icon = "C:\Users\ac00418\Documents\glengyle\resources\icons\CHEVRON.ico"
    $balloon.BalloonTipIcon = $alertLevel
    $balloon.BalloonTipText = $msgText
    $balloon.BalloonTipTitle = $msgTitle
    $balloon.Visible = $true

    $balloon.ShowBalloonTip($Timeout)


}


function Kill-Balloon {

    $Script:balloon.Dispose()
    Remove-Variable -Scope Script -Name balloon

}
