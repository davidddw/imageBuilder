Write-Host "Delete livecloud User"
$UserExist = [ADSI]::Exists("WinNT://livecloud-2012/livecloud")
if ($UserExist) {
    [ADSI]$server="WinNT://livecloud-2012"
    $server.delete("user", "livecloud")
}
