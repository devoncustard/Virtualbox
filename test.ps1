param ([string]$templatepath)

$csv=import-csv $templatepath

foreach ($record in $csv)
{
$record
}

