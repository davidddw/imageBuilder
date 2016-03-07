@ECHO off
:set MACLIST=52:54:00:CF:09:2D
SET "ctrl_ip_address=%1"
SET "ctrl_mac=%2"
SET "init_password=%3"
SET "hypervisor_ip=%4"

SET vagent_download_url=http://%hypervisor_ip%:20016/v1/static/vagent.tar.gz
SET vagent_local=C:\Windows\Temp\vagent.tar.gz
SET curl=C:\Windows\System32\curl.exe
SET sevenZip=C:\Windows\System32\7za.exe
SET python=C:\Progra~1\python\python.exe

setlocal enableDelayedExpansion
set MACLIST=%ctrl_mac%
for /f "delims=" %%a in ('getmac /fo csv /nh /v') do (
    set line=%%a&set line=!line:"=,!
    for /f "delims=,,, tokens=1,3" %%b in ("!line!") do (
        set name=%%b
        set mac=%%c
        call set mactest=%%MACLIST:!mac!=%%
        if not "!MACLIST!"=="!mactest!" (
            netsh int ip set address "!name!" static %ctrl_ip_address% 255.255.0.0
        )
    )
)
net user Administrator %init_password%
@ping %hypervisor_ip% -n 1
%curl% -s %vagent_download_url% -o %vagent_local%
IF NOT EXIST "C:\Windows\vagent" (
    %sevenZip% x %vagent_local% -so | %sevenZip% x -aoa -si -ttar -oC:\Windows > nul
    %python% C:\Windows\vagent\vagent_service.py install
    %python% C:\Windows\vagent\vagent_service.py start
    sc config "vagent" start= auto > nul
    sc description "vagent" "LiveCloud Agent for VM" > nul
) ELSE (
    taskkill /F /im pythonservice.exe > nul
    rd /s /q C:\Windows\vagent
    %sevenZip% x %vagent_local% -so | %sevenZip% x -aoa -si -ttar -oC:\Windows > nul
    net start vagent > nul
)