$a

switch ($env:BOOTSTRAP)
    {
        "VirtualBox" { $a=get-content z:\instance.txt }
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

"We're going to rename this computer to " + $h.get_item("Hostname")
$newname=$h.get_item("Hostname")
$computerinfo=get-wmiobject -Class Win32_ComputerSystem
$computerinfo.rename($newname)

