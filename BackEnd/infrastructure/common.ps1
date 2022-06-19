Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
# $environment='dev'
$environment=$env:ENVIRONMENT
if ([string]::IsNullOrWhiteSpace($environment)){
    Write-Error -Message "The variable 'environment' was empty"
}

$ResourceGroup="rg-demo-backendwebapp-$environment"

# $Location="southeastasia"
$Location="uksouth"
$PlanName="WebAppPlanName"
$WebAppName="ddtlab-webapp-$environment"

$StaticSiteStorageAccount="saustorageaccount001$environment"
$StaticSiteResourceGroup="rg-demo-staticwebsite-with-cicd"