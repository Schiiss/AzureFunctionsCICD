<#
.SYNOPSIS
Sets security on various resources post deployment
.AUTHOR
nullptr
#>

Select-AzSubscription -SubscriptionId c2c6e684-985c-4a2e-98ea-128c6d48609b

$faObject = Get-AzFunctionApp -Name functionappcicd98765 -ResourceGroupName connerDevOps

$msiId = $faObject.IdentityPrincipalId

$msiId

Set-AzKeyVaultAccessPolicy -VaultName connerCiCD `
                           -ObjectId $msiId `
                           -PermissionsToSecrets get,list `
                           -PassThru `
                           -BypassObjectIdValidation