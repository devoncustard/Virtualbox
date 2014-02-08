#This gets the status of a cert
$obj=$null

$uri="https://puppet.devops.local:8140/devopstest/certificate_status/node1.devops.local"

$obj=invoke-restmethod -uri $uri -Headers @{"Accept"="pson"}
$obj
