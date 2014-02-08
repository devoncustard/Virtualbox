$host.version
$uri="https://puppet.devops.local:8140/devopstest/certificate_status/node1.devops.local"
$headers="Accept: pson"
invoke-restmethod -uri $uri -Headers @{"Accept"="pson"}