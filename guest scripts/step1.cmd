REM Remove this scheduled task. Create another to start on next boot called Step 2. Finally run the rename script and reboot the server
schtasks /Delete  /TN "Step 1" /F
schtasks /create /ru "SYSTEM" /SC ONSTART /TN "Step 2" /TR "c:\windows\setup\scripts\step2.cmd" /RL HIGHEST
powershell -ExecutionPolicy Unrestricted -File c:\windows\setup\scripts\renamehost.ps1
shutdown /r /t 2
