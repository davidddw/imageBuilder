
$ctrl_ip_address = $args[0]
$ctrl_mac = $args[1]
$init_password = $args[2]
$hypervisor_ip = $args[3]

$vagent_download_url = "http://$hypervisor_ip:20016/v1/static/vagent.tar.gz"
$vagent_local = C:\Windows\Temp\vagent.tar.gz
$python = C:\Progra~1\python\python.exe

function xzFile($src, $dest) {
    $sevenZip = "C:\Windows\System32\7za.exe"
    & cmd "/c $sevenZip x `"$src`" -so | $sevenZip x -aoa -si -ttar -o`"$dest`""
}

function download($url, $dest) {
    Write-Host "Downloading $url"
    ( New-Object System.Net.WebClient).DownloadFile( $url, $dest)
}

$UserExist = [ADSI]::Exists("WinNT://livecloud-2008/livecloud")
if ($UserExist) {
    [ADSI]$server="WinNT://livecloud-2008"
    $server.delete("user", "livecloud")
}

$hostname = $env:computername
Set objUser = GetObject("WinNT://livecloud-2008/Administrator, user")
objUser.SetPassword "testpassword"

$hashMACIP = @{}
$objWin32NAC = Get-WmiObject win32_networkadapterconfiguration | select description, macaddress
foreach ($objNACItem in $objWin32NAC) {
    if ($objNACItem.MACAddress.length -gt 0) {
        if (-not ($hashMACIP.ContainsKey( $objNACItem.MACAddress ))) {
            $hashMACIP.Add( $objNACItem.MACAddress, $objNACItem.description )
        }
    }
}
if ($hashMACIP[$ctrl_mac] -gt 0) {
    Set-NetworkAdapterIPAddress $hashMACIP[$ctrl_mac] -IPAddress $ctrl_ip_address -Subnet 255.255.0.0
}

download $url"vagent.tar.gz" $tmp_dir"vagent.tar.gz"
if (!(Test-Path "C:\Windows\vagent" )) {
    Write-Host "Config Vagent...."
    xzFile $vagent_local "C:\Windows"
    $python = "C:\Program Files\python\python.exe"
    & $python C:\Windows\vagent\vagent_service.py install
    & $python C:\Windows\vagent\vagent_service.py start
    Set-Service -Name "vagent" -StartupType Automatic -description "LiveCloud Agent for VM"
} else {
    stop-process -name pythonservice.exe
    remove-item -Force -Recurse C:\Windows\vagent
    xzFile $vagent_local "C:\Windows"
    Start-Service "vagent"
}
