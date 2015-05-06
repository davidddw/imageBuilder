$python_download_url = "http://172.16.39.10/04_ISO/python-2.7.8.amd64.msi"

if (!(Test-Path "C:\python27" )) {
    Write-Host "Downloading $python_download_url"
    ( New-Object System.Net.WebClient).DownloadFile( $python_download_url , "C:\Windows\Temp\python-2.7.8.amd64.msi" )
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Windows\Temp\python-2.7.8.amd64.msi /qn /l*v log.txt ALLUSERS=1 TARGETDIR=C:\python27" -Wait -Passthru -NoNewWindow
}

[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\python27\;C:\python27\Scripts\", "User")

$virtio_download_url = "http://172.16.39.10/04_ISO/virtiodriver.zip"
if (!(Test-Path "C:\Windows\virtiodirvers" )) {
    Write-Host "Downloading $virtio_download_url"
    ( New-Object System.Net.WebClient).DownloadFile( $virtio_download_url, "C:\Windows\Temp\virtiodriver.zip" )
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace("C:\Windows\Temp\virtiodriver.zip")
    foreach($item in $zip.items()) {
        $shell.Namespace("C:\Windows" ).copyhere($item)
    }
}

bcdedit /loadoptions 'DDISABLE_INTEGRITY_CHECKS'
bcdedit /set 'loadoptions' 'DDISABLE_INTEGRITY_CHECKS'
bcdedit /set 'TESTSIGNING' 'ON'
pnputil -i -a  C:\Windows\virtiodriver\*.INF
