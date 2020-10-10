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

    [object]ExecuteAPICall([string]$url, [string]$method) {
        $response = Invoke-WebRequest -Method $method -Uri $url -Headers $this.GetHeaders() 
        Write-Verbose ("RESPONSE: {0}" -f $response)
        return ($response | ConvertFrom-Json)
    }
}