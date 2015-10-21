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

$virtio_download_url = "http://172.16.2.254/Packer/virtiodriver2k8_openstack.tar.gz"
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
