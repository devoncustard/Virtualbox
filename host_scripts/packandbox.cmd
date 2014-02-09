REM %1 Box name %2 folder path to store new box %3 Virtualbox VM to package

call vagrant box remove %1
del %2\%1.box
call vagrant package --output %2\%1.box --base %3
call vagrant box add %1 %2\%1.box