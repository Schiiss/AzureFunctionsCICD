<#
.SYNOPSIS
Sets security on various resources post deployment
.AUTHOR
nullptr
#>
[cmdletbinding(SupportsShouldProcess = $true)]
param(
    [string]$subId = "c2c6e684-985c-4a2e-98ea-128c6d48609b"
)

. "$PSScriptRoot.\azureCmdltUtility.ps1"

$authHelper = [Auth]::new($subId)
$functionAppHelper = [FunctionApps]::new()

Write-Host "Checking Subscription"
$checkSubId = $authHelper.CheckSubscriptionContext()
$validatedSubId = $checkSubId.Subscription.Id
if ($validatedSubId -ne $subId) {
    Write-Output ("Wrong Subscription: {0}" -f $validatedSubId)
    Write-Output ("Logging you into: {0}" -f $subId)
    $authHelper.Login()
    $authHelper.CheckSubscriptionContext()
}
else {
    Write-Output ("Correct Subscription: {0}" -f $validatedSubId)
}

$faObject = $functionAppHelper.GetFunctionApp("functionappcicd98765", "connerDevOps")

$msiId = $faObject.IdentityPrincipalId

$msiId

Set-AzKeyVaultAccessPolicy -VaultName connerCiCD `
                           -ObjectId $msiId `
                           -PermissionsToSecrets get,list `
                           -PassThru `
                           -BypassObjectIdValidation