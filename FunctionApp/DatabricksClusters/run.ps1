using namespace System.Net

using module ./Modules/databricksUtility.psm1

param($Request, $TriggerMetadata)

$databricksHelper = [DatabricksCLI]::new($env:DatabricksURL,$env:DatabricksPAT)

$test = $databricksHelper.ListClusters()

Push-OutputBinding -Name response -Value ([HttpResponseContext]@{
    StatusCode = [System.Net.HttpStatusCode]::OK
    Body = $test
})