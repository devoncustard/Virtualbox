
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




"Waiting for a request for $($certificate) to be generated"

$flag=0
$signed=0
do
    {
            $flag++;
            $requeststatus=$null
            $obj=$null
            $obj=GetCertState $puppetmaster $environment $certificate
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
                    $flag=100
                }
            }
            trap { ".";continue}
            Start-Sleep -s 15
        
    }while ( $flag -lt 100)

