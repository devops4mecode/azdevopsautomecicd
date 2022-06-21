. $PSScriptRoot\common.ps1

Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"

$NumOfWorkers=2
$PlanSKu="Free"

Write-Host "Creating Resource Group $ResourceGroup "
az group create --name $ResourceGroup --location $Location

Write-Host "Creating plan $PlanName"
az appservice plan create --name $PlanName --resource-group $ResourceGroup --sku $PlanSKu --number-of-workers $NumOfWorkers

Write-Host "Creating Web App $WebAppName"
az webapp create --name $WebAppName --plan $PlanName --resource-group $ResourceGroup

Write-Host "Setting configuration parameters"
$setting=@{}
    $setting.Add("key001","value001")
    $setting.Add("key002","value002")
az webapp config appsettings set -g $ResourceGroup -n $WebAppName --settings $setting

Write-Host "Removing all CORS sites"
az webapp cors remove --resource-group $ResourceGroup --name $WebAppName --allowed-origins

$webEndPoint="https://ddtuksouthstracc001$environment.z33.web.core.windows.net"
$corsUrls=@($webEndPoint)
 foreach ($corsUrl in $corsUrls) {
        Write-Host "Adding CORS url $corsUrl"
        az webapp cors add --resource-group $ResourceGroup --name $WebAppName --allowed-origins $corsUrl
    }  