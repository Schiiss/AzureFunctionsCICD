<#
.SYNOPSIS
This utility file contains classes and methods that can be called to interact with azure resources

.AUTHOR
nullptr
#>

class Auth {
    [string]$subId

    Auth([string]$subId) {
        $this.subId = $subId
    }

    [object]Login() {
        $subscription = Select-AzSubscription -SubscriptionId $this.subId
        return $subscription
    }

    [object]CheckSubscriptionContext() {
        $subscriptionContext = Get-AzContext
        return $subscriptionContext
    }   
}

class FunctionApps {
    [object]GetFunctionApp([string]$name, [string]$resourceGroup) {
        $faObject = Get-AzFunctionApp -Name $name -ResourceGroupName $resourceGroup
        return $faObject
    }

}

class KeyVaults {
    SetKeyVaultSecretPolicy([string]$vaultName, [string]$objectId) {
        Set-AzKeyVaultAccessPolicy -VaultName $vaultName `
            -ObjectId $objectId `
            -PermissionsToSecrets get, list `
            -PassThru `
            -BypassObjectIdValidation
    }

}