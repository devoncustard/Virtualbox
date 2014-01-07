$a

switch ($env:BOOTSTRAP)
    {
        "VirtualBox" { $a=get-content d:\instance.txt }
        "Test" { $a=get-content C:\dropbox\scripts\Sysprep\instance.txt
                 "This script is running on your local test machine Joe!"}
        default { "No Virtual host defined. Unable to locate metadata "
                  exit                  
                }

    }
          
$h=@{}
foreach ($i in $a)
{
    $data=$i.split(":");
    $h.Add($data[0],$data[1]);
}
$puppetmaster=$h.get_item("PuppetFQDN")
$environment=$h.get_item("Environment")
$domain=$h.get_item("Domain")
$hostname=$h.get_item("Hostname")
write-output "[main]" | out-file -encoding ascii c:\programdata\puppetlabs\puppet\etc\puppet.conf
write-output "certname=$hostname.$domain" | out-file -encoding ascii -append c:\programdata\puppetlabs\puppet\etc\puppet.conf
write-output "server=$puppetmaster" | out-file -encoding ascii -append c:\programdata\puppetlabs\puppet\etc\puppet.conf
write-output "pluginsync=true" | out-file -encoding ascii -append c:\programdata\puppetlabs\puppet\etc\puppet.conf
write-output "autoflush=true" | out-file -encoding ascii -append c:\programdata\puppetlabs\puppet\etc\puppet.conf
write-output "environment=$environment" | out-file -encoding ascii -append c:\programdata\puppetlabs\puppet\etc\puppet.conf

 