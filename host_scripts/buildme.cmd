
powershell -ExecutionPolicy Unrestricted -File prov_vbox.ps1 -boxname Win2008 -boxos windows -hostname %1 -domain devops.local -puppet puppet.devops.local -environment joe -user vagrant -password Vag-rant1 -classes mcollective_deploy,sysbuild
