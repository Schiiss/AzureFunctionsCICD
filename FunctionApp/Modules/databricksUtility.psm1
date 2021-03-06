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
        return $this.ExecuteAPICall($uri, "Get")
    }

    [object]GetClusterByName([string]$clusterName) {
        Write-Verbose ("Getting info for cluster {0}" -f $clusterName)
        $clusters = $this.ListClusters()
        return $clusters.clusters.Where( { $_.cluster_name -eq $clusterName })[0]
    }

    [void]CreateCluster([object]$clusterConfig) {
        Write-Verbose ("Creating cluster {0}" -f $clusterConfig)
        $uri = "https://{0}/api/2.0/clusters/create" -f $this.url
        $this.ExecuteAPICall($uri, "Post", ($clusterConfig | ConvertTo-Json))
    }

    [object]ExecuteAPICall([string]$uri, [string]$method, [string]$body) {
        Write-Information ("Body: " -f ($body | Out-String))
        $response = Invoke-WebRequest -Method $method -Uri $uri -Headers $this.GetHeaders() -Body $body -Verbose
        Write-Information ("RESPONSE: {0}" -f $response)
        return ($response | ConvertFrom-Json)
    }

    [object]ExecuteAPICall([string]$url, [string]$method) {
        $response = Invoke-WebRequest -Method $method -Uri $url -Headers $this.GetHeaders() 
        Write-Verbose ("RESPONSE: {0}" -f $response)
        return ($response | ConvertFrom-Json)
    }
}

class ClusterUtility {

    static [object]GetClusterConfig([string]$clusterName) {
        $clusterConfig = @{
            cluster_name  = $clusterName
            spark_version = "latest-stable-scala2.11"
            node_type_id  = "Standard_D3_v2"
            autoscale     = @{
                min_workers = 2
                max_workers = 3
            }
          
        }

        return (New-Object psobject -Property $clusterConfig)
    }

}