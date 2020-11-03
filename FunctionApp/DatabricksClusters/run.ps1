using namespace System.Net

using module ./Modules/databricksUtility.psm1

param($Request, $TriggerMetadata)

$databricksHelper = [DatabricksCLI]::new($env:DatabricksURL,$env:DatabricksPAT)
$clusterConfig = [ClusterUtility]::GetClusterConfig("connerTempTest")
$httpMethod = $Request.Method

switch ($httpMethod) {
    "GET" {
        $name = $Request.Query.Name
        if (-not $name) {
            $name = $Request.Body.Name
        }
        
        Write-Information ("Getting Cluster Specs For: {0}" -f $name)
        $body = $databricksHelper.GetClusterByName($name)
        Push-OutputBinding -Name response -Value ([HttpResponseContext]@{
                StatusCode  = 200
                ContentType = "application/json; charset=utf-8"
                Body        = $body
            })
        return
        
    }
    "POST" {
        Write-Information ("Deploying Cluster for {0}" -f ($clusterConfig | ConvertTo-Json | Out-String))
        try {
            $databricksHelper.CreateCluster($clusterConfig)
        }
        catch {
            Write-Error $_
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = 500
                ContentType = "application/json; charset=utf-8"
                Body = "Could not create cluster"
            })
            return
        }
    }
}

