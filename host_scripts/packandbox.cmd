@echo off
REM %1 Box name %2 folder path to store new box %3 Virtualbox VM to package
if "%1"=="?" goto help

call vagrant box remove %1
del %2\%1.box
call vagrant package --output %2\%1.box --base %3
call vagrant box add %1 %2\%1.box
goto end


:help
echo %%1 - Name of box you are creating
echo %%2 - Folder you are placing the box into
echo %%3 - Name of the Virtualbox you are packaging

:end