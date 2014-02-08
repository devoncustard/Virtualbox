
param ([string]$puppetmaster,[string]$environment,[string]$certificate)
Function GetCertState()
{
param([string]$pm,[string]$en,[string]$ce)

$uri="https://$($pm):8140/$($en)/certificate_status/$($ce)"
invoke-restmethod -uri $uri -Headers @{"Accept"="pson"}
}
Function SignCert()
{
param([string]$pm,[string]$en,[string]$ce)
    $uri="https://$($pm):8140/$($en)/certificate_status/$($ce)"
    invoke-restmethod -Method PUT -uri $uri -Headers @{"Content-Type"="text/pson"} -Body "{""desired_state"":""signed""}"
}






$flag=0
$signed=0
do{
    $requeststatus=$null
    $obj=$null
    $obj=GetCertState $puppetmaster $environment $certificate
    $flag++;
    if ($obj -ne $null)
    {
        if ($obj.state -eq "requested")
        {
            $o=SignCert $puppetmaster $environment $certificate
            $signed=1
            $obj=$null            
        }
        if (($obj.state -eq "signed") -and ($signed -eq 1))
        {
            $flag=20
        }
    }
    $flag
    Start-Sleep -s 15
}while ( $flag -lt 20)

