using namespace System.Net

param($Request, $TriggerMetadata)

$sithLords = Get-Content .\sithLords.json | ConvertFrom-Json

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    headers = @{'content-type'='application\json'}
    StatusCode = [httpstatuscode]::OK
    Body = $sithLords.sithLords
})