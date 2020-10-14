<#
.SYNOPSIS
This script is the main utility file (helper) that is intended to be called from external scripts
to interact with the databricks API
.AUTHOR
nullptr
#>

class DatabricksCLI {
    [string]$apiKey
    [string]$url

    [object]GetHeaders() {
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Authorization", "Bearer {0}" -f $this.apiKey)
        $headers.Add("Content-Type", "application/json")
        return $headers
    }

    DatabricksCLI([string]$url, [string]$apiKey) {
        $this.url = $url
        $this.apiKey = $apiKey
    }

    [object]ListClusters() {
        $uri = "https://{0}/api/2.0/clusters/list" -f $this.url
        return $this.ExecuteADPAPICall($uri, "Get")
    }

    [object]ExecuteAPICall([string]$url, [string]$method) {
        $response = Invoke-WebRequest -Method $method -Uri $url -Headers $this.GetADBHeaders() 
        Write-Verbose ("RESPONSE: {0}" -f $response)
        return ($response | ConvertFrom-Json)
    }
}

class ClusterUtility {

    static [object]GetClusterConfig([string]$clusterName) {
        $clusterConfig = @{
            cluster_name            = $clusterName
            spark_version           = "latest-stable-scala2.11"
            enable_elastic_disk     = $true
            autotermination_minutes = 10
            num_workers             = 1
            spark_env_vars          = @{
                PYSPARK_PYTHON = "/databricks/python3/bin/python3"
            }
            node_type_id            = "Standard_D3_v2"
          
        }

        return (New-Object psobject -Property $clusterConfig)
    }

}