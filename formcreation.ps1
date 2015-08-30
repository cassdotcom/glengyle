$funLib = "C:\Users\ac00418\Documents\WindowsPowerShell\FunctionLibrary\FunctionScripts"
gci $funLib | % {. $_.FullName}

add-WpfAccelerators

$xaml = [io.file]::ReadAllText("C:\Users\ac00418\Documents\glengyle\SplashPage.xaml")
$window = [System.Windows.Window][System.Windows.Markup.XamlReader]::Parse($xaml)


[GroupBox]$groupBox = $window.FindName("gBox")
[MenuItem]$menuFile = $window.FindName("File")
$menuFile.Add_Click({$groupBox.Content.Text = "File Options"})
[MenuItem]$reports = $window.FindName("Reports")
 $reports.Add_Click({$groupBox.Content.AddText("report data")})



$window.ShowDialog() | out-null
