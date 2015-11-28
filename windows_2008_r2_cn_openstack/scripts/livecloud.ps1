Write-Host "Delete livecloud User"
$UserExist = [ADSI]::Exists("WinNT://livecloud-2008/livecloud")
if ($UserExist) {
    [ADSI]$server="WinNT://livecloud-2008"
    $server.delete("user", "livecloud")
}

function xzFile($src, $dest) {
    $sevenZip = "C:\Windows\System32\7za.exe"
    & cmd "/c $sevenZip x `"$src`" -so | $sevenZip x -aoa -si -ttar -o`"$dest`""
}

function download($url, $dest) {
    Write-Host "Downloading $url"
    ( New-Object System.Net.WebClient).DownloadFile( $url, $dest)
}

$url = "http://172.16.2.254/Packer/"
$bin_dir = "C:\Windows\System32\"
$tmp_dir = "C:\Windows\Temp\"

download $url"tools/7za.exe" $bin_dir"7za.exe"
download $url"tools/curl.exe" $bin_dir"curl.exe"
download $url"tools/virtiodriver2k8_openstack.tar.gz" $tmp_dir"virtiodriver.tar.gz"

xzFile "C:\Windows\Temp\python.tar.gz" "C:\Windows\Temp"

if (!(Test-Path "C:\Windows\virtiodriver" )) {
    Write-Host "Install VirtIO Driver...."
    xzFile "C:\Windows\Temp\virtiodriver.tar.gz" "C:\Windows"
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
}
