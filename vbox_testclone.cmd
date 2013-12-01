rem %1 hostname %2 puppetmaster fqdn

mkdir .\%1
echo Hostname:%1: > .\%1\instance.txt
echo PuppetFQDN:%2: >> .\%1\instance.txt
.\mkisofs -l -J -r -V "METADATA" -o ".\%1.iso" ".\%1"
rd %1 /s /q
"c:\program files\oracle\virtualbox\vboxmanage" clonevm Cloneme --name %1  --basefolder c:\vms --register
"c:\program files\oracle\virtualbox\vboxmanage" storageattach %1 --storagectl IDE --port 1 --device 0 --type dvddrive --medium .\%1.iso
"c:\program files\oracle\virtualbox\vboxmanage" startvm %1