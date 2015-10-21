Write-Host "Delete livecloud User"
$UserExist = [ADSI]::Exists("WinNT://livecloud-2008/livecloud")
if ($UserExist) {
    [ADSI]$server="WinNT://livecloud-2008"
    $server.delete("user", "livecloud")
}