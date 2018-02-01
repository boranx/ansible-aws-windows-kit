$JDK_VER = '9.0.4'
$JDK_FULL_VER = '9.0.4+11'
$JDK_PATH = 'JDK1.9.0'
$JRE_PATH = 'JRE1.9.0'
$InstallJDKDir = "C:\Java\$JDK_PATH"
$InstallJREDir = "C:\Java\$JRE_PATH"
$JavaDownloadPath = 'C:\Java\Downloads'
$Source64 = "http://download.oracle.com/otn-pub/java/jdk/${JDK_FULL_VER}/c2514751926b4512b076cc82f959763f/jdk-${JDK_VER}_windows-x64_bin.exe"
$Destination64 = "$JavaDownloadPath\$JDK_VER-x64.exe"
$Client = New-Object System.Net.WebClient
$Cookie = "oraclelicense=accept-securebackup-cookie"
$Client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $Cookie)

Write-Host 'Checking if Java is already installed'
if (!(Test-Path $JavaDownloadPath)) {
    New-Item $JavaDownloadPath -type directory | Out-Null  
    Write-Host "$JavaDownloadPath Directory is created"
}
if (Test-Path "$JavaDownloadPath\$JDK_VER-*") {
    Write-Host 'No need to Install Java'
    Exit
}

Write-Host 'Determining OS'
if ([System.IntPtr]::Size -eq 4) { 
    Write-Host "OS is 32-bit" 
    Write-Host "Java 9 is not supported."
    } 
else { 
    Write-Host "OS is 64-bit" 
    Write-Host "Downloading x64 to $Destination64"
    $Client.DownloadFile($Source64, $Destination64)
    if (!(Test-Path $Destination64)) {
        Write-Host "Downloading $Destination64 failed"
        Exit
        }
    Write-Host 'File Downloaded'
    }

try {
    Write-Host 'Installing JDK'
    $Proc = Start-Process -FilePath "$Destination64" -ArgumentList "/s INSTALLDIR=\`"$InstallJDKDir\`" /INSTALLDIRPUBJRE=$InstallJREDir REBOOT=ReallySuppress AUTO_UPDATE=0 /L C:\Java\Installation.log" -Wait -PassThru
    $Proc.waitForExit()
    Write-Host 'Installation Done.'
} catch [exception] {
    write-host '$_ is' $_
    write-host '$_.GetType().FullName is' $_.GetType().FullName
    write-host '$_.Exception is' $_.Exception
    write-host '$_.Exception.GetType().FullName is' $_.Exception.GetType().FullName
    write-host '$_.Exception.Message is' $_.Exception.Message
}

if ((Test-Path "$InstallJDKDir\bin\java.exe") -and (Test-Path "$InstallJREDir\bin\java.exe")) {
    Write-Host 'Java JDK and JRE installed successfully.'
}
Write-Host 'Setting up Path variables.'
try {
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $InstallJDKDir, "Machine")
    [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";$InstallJDKDir\bin", "Machine")
}
catch {
    Write-Host 'Failed during Setting up.'
}
Write-Host 'Done. Goodbye.'
