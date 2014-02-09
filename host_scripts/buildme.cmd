@echo %1 %2 %3 %4 %5 %6 %7 %8 %9 


powershell -ExecutionPolicy Unrestricted -File c:\github\virtualbox\host_scripts\prov_vbox.ps1 -boxname %1 -boxos %2 -hostname %3 -domain %4 -puppet %5 -environment %6 -user %7 -password %8 -classes %9
