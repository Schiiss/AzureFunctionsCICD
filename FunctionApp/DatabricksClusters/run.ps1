using namespace System.Net

using module ./Modules/databricksUtility.psm1

param($Request, $TriggerMetadata)

$databricksHelper = [DatabricksCLI]::new($env:DatabricksURL,$env:DatabricksPAT)
$httpMethod = $Request.Method
$clusters = $databricksHelper.ListClusters()


switch($httpMethod){
    "GET"{
        Push-OutputBinding -Name response -Value ([HttpResponseContext]@{
            StatusCode = 200
            Body       = $clusters
        })
    }
    "POST"{
        Push-OutputBinding -Name response -Value ([HttpResponseContext]@{
            StatusCode = 200
            Body       = "test"
        })
    }
}
