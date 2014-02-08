#revoke cert
#curl -k -X PUT -H "Content-Type: text/pson" --data '{"desired_state":"revoked"}' https://puppetmaster:8140/production/certificate_status/client.network.address
#then delete all cert data
#curl -k -X DELETE -H "Accept: pson" https://puppetmaster:8140/production/certificate_status/client.network.address
param ([string]$puppetmaster,[string]$environment,[string]$certificate)
Function RevokeCert()
{
param([string]$pm,[string]$en,[string]$ce)
    $uri="https://$($pm):8140/$($en)/certificate_status/$($ce)"
    invoke-restmethod -Method PUT -uri $uri -Headers @{"Content-Type"="text/pson"} -Body "{""desired_state"":""revoked""}"
}
Function CertStatus()
{
    param([string]$pm,[string]$en,[string]$ce)
    $uri="https://$($pm):8140/$($en)/certificate_status/$($ce)"
    invoke-restmethod -uri $uri -Headers @{"Accept"="pson"}
}
Function DeleteCertData()
{
    param([string]$pm,[string]$en,[string]$ce)
    $uri="https://$($pm):8140/$($en)/certificate_status/$($ce)"
    invoke-restmethod -Method DELETE -uri $uri -Headers @{"Accept"="pson"}
}


$obj=$null
$obj=CertStatus $puppetmaster $environment $certificate
$obj
RevokeCert $puppetmaster $environment $certificate
$obj=$null
$obj=CertStatus $puppetmaster $environment $certificate
$obj
DeleteCertData $puppetmaster $environment $certificate
$obj=$null
$obj=CertStatus $puppetmaster $environment $certificate
$obj
