@ECHO off
SET "url=%1"
SET vagent_download_url="http://%url%/Packer/vagent.tar.gz"
SET vagent_local=C:\Windows\Temp\vagent.tar.gz
SET curl=C:\Windows\System32\curl.exe
SET sevenZip=C:\Windows\System32\7za.exe
set python=C:\PROGRA~1\python\python.exe
%curl% -s %vagent_download_url% -o %vagent_local%
IF NOT EXIST "C:\Windows\vagent" (
    %sevenZip% x %vagent_local% -so | %sevenZip% x -aoa -si -ttar -oC:\Windows > nul
    %python% C:\Windows\vagent\vagent.py install
    %python% C:\Windows\vagent\vagent.py start
    sc config "vagent" start= auto > nul
    sc description "vagent" "LiveCloud Agent for VM" > nul
) ELSE (
    %python% C:\Windows\vagent\vagent.py stop > c:\1.log
    taskkill /F /IM pythonservice.exe >> c:\1.log
    rd /s /q C:\Windows\vagent >> c:\1.log
    %sevenZip% x %vagent_local% -so | %sevenZip% x -aoa -si -ttar -oC:\Windows  >> c:\1.log
    %python% C:\Windows\vagent\vagent.py start >> c:\1.log
)