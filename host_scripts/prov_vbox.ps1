param ([string]$boxname, [string]$boxos, [string]$hostname, [string]$domain, [string]$puppet, [string]$environment, [string]$user, [string]$password, [string]$classes)


  

# Get environment variables

$VAGRANT_BASE_FOLDER=$env:VAGRANT_BASE_FOLDER

#Tidy up VAGRANT directory if it exists
$p=$hostname +"."+ $domain
echo "path is $p"

if (Test-Path $VAGRANT_BASE_FOLDER\$environment\$p)
{
    #xmppalert -m "Removing old install" -c bothouse@conference.gibber.devops.local
    cd $VAGRANT_BASE_FOLDER\$environment\$p
    if (Test-Path vagrantfile) {vagrant destroy -f}
    cmd.exe /c del *.* /s /q
    if (Test-Path .vagrant) {cmd /c rd .vagrant /s/q}
    
}
else
{
    #xmppalert -m "Creating new vagrant folder" -c bothouse@conference.gibber.devops.local
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

# Generate bash script to clean up puppet etc.
#xmppalert -m "Cleaning up old certs and adding details to ENC" -c bothouse@conference.gibber.devops.local





# Create the vagrant file
#xmppalert -m "Creating vagrant file" -c bothouse@conference.gibber.devops.local

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
write-output "        guest.winrm.timeout=3600" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.windows.set_work_network" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
write-output "        guest.vm.network :forwarded_port, guest:5985, host:5985, auto_correct: true" |out-file -encoding ascii -append $VAGRANT_BASE_FOLDER\$environment\$p\vagrantfile
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

mkisofs -l -J -r -V "METADATA" -o ".\$ip" "ISO"

#xmppalert -m "Starting instance, go and make a cuppa." -c bothouse@conference.gibber.devops.local

# Generate bash script to clean up puppet etc.
#write-output "puppet cert clean ${hostname}.${domain}" | out-file -encoding ascii "${p}.sh"
#write-output "cd /usr/share/puppet-dashboard" | out-file -encoding ascii -append "${hostname}.${domain}.sh"
#write-output "rake RAILS_ENV=production node:del name=${hostname}.${domain}" | out-file -encoding ascii -append "${hostname}.${domain}.sh"
#write-output "rake RAILS_ENV=production node:add name=${hostname}.${domain} classes=${classes}" | out-file -encoding ascii -append "${hostname}.${domain}.sh"


vagrant up
#xmppalert -m "Build complete, please check puppet dashboard to see deployment status" -c bothouse@conference.gibber.devops.local
pause