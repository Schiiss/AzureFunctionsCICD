using module ..\FunctionApp\Modules\databricksUtility.psm1

Describe "Cluster Utilities" {
    $clusterName = "test1"
    $clusterConfig = [ClusterUtility]::GetClusterConfig($clusterName)

    It "Returns Cluster Name"{
        $clusterConfig.cluster_name | Should -Be $clusterName
    }
}