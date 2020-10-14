<#
.AUTHOR
nullptr
#>
param(
    [string]$subId = "c2c6e684-985c-4a2e-98ea-128c6d48609b"
)

. "$PSScriptRoot.\azureCmdltUtility.ps1"

$authHelper = [Auth]::new($subId)
$functionAppHelper = [FunctionApps]::new()
$keyVaultHelper = [KeyVaults]::new()

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

Write-Output ("Found MSI for function app with the ID {0}" -f $msiId)

Write-Output ("Adding MSI to KV")

$keyVaultHelper.SetKeyVaultSecretPolicy("connerCiCD", $msiId)