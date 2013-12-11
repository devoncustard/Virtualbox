REM Create the scheduled task Step 1 that will start on next boot. Then force a reboot
schtasks /create /ru "SYSTEM" /SC ONSTART /TN "Step 1" /TR "c:\windows\setup\scripts\step1.cmd" /RL HIGHEST
shutdown /r /t 2