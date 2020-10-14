using module ./FunctionApp/Modules/databricksUtility.psm1
$clusterUtilityHelper = [ClusterUtility]::new()

Describe "Cluster Utilities" {
    $clusterName = "test1"
    $clusterUtilityHelper.GetClusterConfig($clusterName)

    It "Returns Cluster Name"{
        $clusterConfig.cluster_name | Should -Be $clusterName
    }
}