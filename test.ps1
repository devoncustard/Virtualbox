param ([string]$templatepath)

$templatepath="c:\github\virtualbox\testtemp.csv"
$csv=import-csv $templatepath

foreach ($record in $csv)
{
start-process "cmd.exe" "/c c:\github\virtualbox\host_scripts\buildme.cmd $($record.box) $($record.os) $($record.host) $($record.domain) $($record.Puppetmaster) $($record.Environment) $($record.SysprepUser) $($record.SysprepPassword) $($record.Classes)" -NoNewWindow -Wait

}

