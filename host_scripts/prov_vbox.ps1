param ([string]$boxname, [string]$boxos, [string]$hostname, [string]$domain, [string]$puppet, [string]$environment, [string]$user, [string]$password, [string]$classes)

# Get environment variables

$VAGRANT_BASE_FOLDER=$env:VAGRANT_BASE_FOLDER

#Tidy up VAGRANT directory if it exists
$p=$hostname +"."+ $domain


Start-Process powershell -argument  "c:\github\virtualbox\host_scripts\revokecert.ps1 $puppet $environment $p"
if (Test-Path $VAGRANT_BASE_FOLDER\$environment\$p)
{
    cd $VAGRANT_BASE_FOLDER\$environment\$p
    if (Test-Path vagrantfile) {vagrant destroy -f}
    cmd.exe /c del *.* /s /q
    if (Test-Path .vagrant) {cmd /c rd .vagrant /s/q}
}
else
{
    cd $VAGRANT_BASE_FOLDER
   
    if (!(Test-Path $environment)) 
        {mkdir $environment}
    cd $environment
    
    mkdir $P
    cd $p
}

if (!(Test-Path ISO)){mkdir ISO}

vagrant init
del vagrantfile
$ip=$p+".iso"
# Create the vagrant file
write-output "# -*- mode: ruby -*-" | out-file -encoding ascii $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "# vi: set ft=ruby :"|out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!"|out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "VAGRANTFILE_API_VERSION = ""2""" | out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|"|out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "    config.vm.boot_timeout=600"|out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "    config.vm.define :$hostname do |guest|" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.box= ""$boxname""" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.guest = :$boxos" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.windows.halt_timeout=25" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.winrm.username = ""$user""" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.winrm.password=""$password""" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.winrm.max_tries=30" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.winrm.timeout=3600" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.windows.set_work_network" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.network :forwarded_port, guest:5985, host:5985, id:""winrm"", auto_correct: true" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.network ""public_network"", :bridge => 'Ethernet'" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.provider :virtualbox do |vb|" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "            vb.gui = true" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "            vb.customize [""modifyvm"", :id, ""--memory"", ""1024""]" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "            vb.customize [""modifyvm"", :id, ""--name"", ""$p""]" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "            vb.customize [""storageattach"", :id, ""--storagectl"", ""IDE"", ""--port"", ""1"", ""--device"", ""0"", ""--type"", ""dvddrive"", ""--medium"", ""$ip""]" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        end" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "    end" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "end" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile

#xmppalert -m "Generating metadata" -c bothouse@conference.gibber.devops.local
write-output "Hostname:${hostname}:" | out-file -encoding ascii ISO\instance.txt
write-output "PuppetFQDN:${puppet}:" | out-file -encoding ascii -append ISO\instance.txt
write-output "Domain:${domain}:" | out-file -encoding ascii -append ISO\instance.txt
write-output "Environment:${environment}:" | out-file -encoding ascii -append ISO\instance.txt

c:\github\virtualbox\tools\mkisofs -l -J -r -V "METADATA" -o ".\$ip" "ISO"

Start-Process powershell -argument  "c:\github\virtualbox\host_scripts\signcert.ps1 $puppet $environment $p"

vagrant up
pause