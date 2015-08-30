Write-Host "Delete livecloud User"
$UserExist = [ADSI]::Exists("WinNT://livecloud-2008/livecloud")
if ($UserExist) {
	[ADSI]$server="WinNT://livecloud-2008"
	$server.delete("user", "livecloud")
}

$python_download_url = "http://172.16.2.254/Packer/python-2.7.8.amd64.msi"
if (!(Test-Path "C:\python27" )) {
    Write-Host "Downloading $python_download_url"
    $msiFile = "C:\Windows\Temp\python-2.7.8.amd64.msi"
    ( New-Object System.Net.WebClient).DownloadFile( $python_download_url , "$msiFile" )
    $arguments = @(
		"/i"
		"`"$msiFile`""
	    "/qn"
		"/norestart"
		"ALLUSERS=1"
		"TARGETDIR=C:\python27"
	)
	Write-Host "Installing $msiFile....."
	$process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
	if ($process.ExitCode -eq 0){
	    Write-Host "$msiFile has been successfully installed"
	} else {
    	Write-Host "installer exit code  $($process.ExitCode) for file  $($msifile)"
	}
}
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\python27\;C:\python27\Scripts\", "User")

$virtio_download_url = "http://172.16.2.254/Packer/virtiodriver.zip"
if (!(Test-Path "C:\Windows\virtiodriver" )) {
    Write-Host "Downloading $virtio_download_url"
    $driverFile = "C:\Windows\Temp\virtiodriver.zip"
    ( New-Object System.Net.WebClient).DownloadFile( $virtio_download_url, "$driverFile" )
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("$driverFile")
    foreach($item in $zip.items()) {
        $shell.Namespace("C:\Windows" ).copyhere($item)
    }
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

$rar_download_url = "http://172.16.2.254/Packer/WinRAR5.21_x64sc.exe"
if (!(Test-Path "C:\Program Files\WinRAR")) {
    Write-Host "Downloading $rar_download_url"
    (New-Object System.Net.WebClient).DownloadFile($rar_download_url, "C:\Windows\Temp\winrar.exe")
    Start-Process "C:\Windows\Temp\winrar.exe" "/S" -NoNewWindow -Wait
}
