
powershell -ExecutionPolicy Unrestricted -File prov_vbox.ps1 -boxname wintest -boxos windows -hostname %1 -domain devops.local -puppet puppet.devops.local -environment joe -user vagrant -password vagrant -classes mcollective_deploy,sysbuild
