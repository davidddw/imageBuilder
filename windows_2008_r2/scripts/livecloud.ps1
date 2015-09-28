Write-Host "Delete livecloud User"
$UserExist = [ADSI]::Exists("WinNT://livecloud-2008/livecloud")
if ($UserExist) {
	[ADSI]$server="WinNT://livecloud-2008"
	$server.delete("user", "livecloud")
}

$7z_download_url = "http://172.16.2.254/Packer/7z1507-x64.exe"
if (!(Test-Path "C:\Program Files\7-Zip")) {
    Write-Host "Downloading $7z_download_url"
    (New-Object System.Net.WebClient).DownloadFile($7z_download_url, "C:\Windows\Temp\7z1507-x64.exe")
    Start-Process "C:\Windows\Temp\7z1507-x64.exe" "/S" -NoNewWindow -Wait
}

$python_download_url = "http://172.16.2.254/Packer/python-2.7.8.amd64.msi"
if (!(Test-Path "C:\Program Files\python" )) {
    Write-Host "Downloading $python_download_url"
    $msiFile = "C:\Windows\Temp\python-2.7.8.amd64.msi"
    $targetdit = "C:\Program Files\python27"
    ( New-Object System.Net.WebClient).DownloadFile( $python_download_url , "$msiFile" )
    $arguments = @(
        "/i"
        "`"$msiFile`""
        "/qn"
        "/norestart"
        "ALLUSERS=1"
        "TARGETDIR=`"$targetdit`""
	)
	Write-Host "Installing $msiFile....."
	$process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
	if ($process.ExitCode -eq 0){
	    Write-Host "$msiFile has been successfully installed"
	} else {
    	Write-Host "installer exit code  $($process.ExitCode) for file  $($msifile)"
	}
}
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Program Files\python\;C:\Program Files\python\Scripts\", "User")

$virtio_download_url = "http://172.16.2.254/Packer/virtiodriver.tar.gz"
if (!(Test-Path "C:\Windows\virtiodriver" )) {
    Write-Host "Downloading $virtio_download_url"
    $driverFile = "C:\Windows\Temp\virtiodriver.tar.gz"
    ( New-Object System.Net.WebClient).DownloadFile( $virtio_download_url, "$driverFile" )
    $sevenZip = "C:\Program Files\7-zip\7z.exe"
    &$sevenZip e -y -oC:\Windows\Temp $driverFile
    &$sevenZip x -y C:\Windows\Temp\virtiodriver.tar -oC:\Windows
}

$Host.UI.RawUI.WindowTitle = "Installing VirtIO certificate..."
$virtioCertPath = "C:\Windows\virtiodriver\VirtIO.cer"
$virtioDriversPath = "C:\Windows\virtiodriver"
$cacert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($virtioCertPath)
$castore = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::TrustedPublisher,`
           [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)
$castore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$castore.Add($cacert)
Write-Host "Installing VirtIO drivers from: $virtioDriversPath"
$process = Start-process -Wait -PassThru pnputil "-i -a C:\Windows\virtiodriver\*.inf"
if ($process.ExitCode -eq 0){
	Write-Host "VirtIO has been successfully installed"
} else {
    Write-Host "InstallVirtIO failed"
}

$qga_download_url = "http://172.16.2.254/Packer/qemu-ga.64bit.msi"
if (!(Test-Path "C:\Program Files\qemu-ga" )) {
    Write-Host "Downloading $qga_download_url"
    $msiFile = "C:\Windows\Temp\qemu-ga.64bit.msi"
    ( New-Object System.Net.WebClient).DownloadFile( $qga_download_url , "$msiFile" )
    $arguments = @(
		"/i"
		"`"$msiFile`""
	    "/qn"
		"/norestart"
		"ALLUSERS=1"
	)
	Write-Host "Installing $msiFile....."
	$process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
	if ($process.ExitCode -eq 0){
	    Write-Host "$msiFile has been successfully installed"
	} else {
    	Write-Host "installer exit code  $($process.ExitCode) for file  $($msifile)"
	}
	Start-Service "QEMU Guest Agent VSS Provider"
	Start-Service "QEMU Guest Agent"
}

secedit /export /cfg c:\secpol.cfg
$config_file = Get-Content 'C:\secpol.cfg'
$config_file = $config_file -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0'
$config_file = $config_file -replace 'MinimumPasswordLength = 1', 'MinimumPasswordLength = 0'
Set-Content 'c:\secpol.cfg' $config_file
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

$vagent_download_url = "http://172.16.2.254/Packer/vagent.tar.gz"
if (!(Test-Path "C:\Windows\vagent" )) {
    Write-Host "Downloading $vagent_download_url"
    $driverFile = "C:\Windows\Temp\vagent.tar.gz"
    ( New-Object System.Net.WebClient).DownloadFile( $vagent_download_url, "$driverFile" )
    $sevenZip = "C:\Program Files\7-zip\7z.exe"
    &$sevenZip e -y -oC:\Windows\Temp $driverFile
    &$sevenZip x -y C:\Windows\Temp\vagent.tar -oC:\Windows
}

$srvstart_download_url = "http://172.16.2.254/Packer/srvstart.tar.gz"
if (!(Test-Path "C:\Windows\srvstart" )) {
    Write-Host "Downloading $srvstart_download_url"
    $driverFile = "C:\Windows\Temp\srvstart.tar.gz"
    ( New-Object System.Net.WebClient).DownloadFile( $srvstart_download_url, "$driverFile" )
    $sevenZip = "C:\Program Files\7-zip\7z.exe"
    &$sevenZip e -y -oC:\Windows\Temp $driverFile
    &$sevenZip x -y C:\Windows\Temp\srvstart.tar -oC:\Windows
    $srvstart = "C:\Windows\srvstart\srvstart.exe"
    &$srvstart install vagent -c C:\Windows\srvstart\srvstart.ini
    Set-Service -Name "vagent" -StartupType Automatic
    net start vagent
}
