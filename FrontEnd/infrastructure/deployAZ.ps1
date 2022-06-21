param(
    [Parameter(Mandatory=$true)]
    [string]$pathhtml
    )

Set-StrictMode -Version "latest"
$ErrorActionPreference="Stop"
$environment=$env:ENVIRONMENT
if ([string]::IsNullOrWhiteSpace($environment)){
    Write-Error -Message "The variable 'environment' was empty"
}

$Location="uksouth"
$ContainerForStaticContent="`$web"
$ResourceGroup="rg-demo-frontendwebsite-$environment"
$sku='Standard_LRS'
$StaticSiteStorageAccount="ddtuksouthstracc001$environment"
$errordoc="error.html"
$indexdoc="default.html"

Write-Host "Creating Resource Group $ResourceGroup "
az group create --name $ResourceGroup --location $Location

Write-Host "Creating storage account $StaticSiteStorageAccount"
az storage account create --name $StaticSiteStorageAccount --resource-group $ResourceGroup --location $Location --sku $sku

Write-Host "Creating container $ContainerForStaticContent"
az storage container create --name $ContainerForStaticContent --resource-group $ResourceGroup --account-name $StaticSiteStorageAccount | Out-Null

Write-Host "Setting static web app properties"
az storage blob service-properties update --account-name $StaticSiteStorageAccount --static-website --404-document "$errordoc" --index-document "$indexdoc" | Out-Null

Write-Host "Purging existing files in container $ContainerForStaticContent"
az storage blob delete-batch --account-name $StaticSiteStorageAccount --source $ContainerForStaticContent --pattern *.* 

$Sourcefolder=$pathhtml
Write-Host "Uploading files from $Sourcefolder"
az storage blob upload-batch --account-name $StaticSiteStorageAccount --source $Sourcefolder -d '$web'

Write-Host "Show Static Web URL"
az storage account show --name $StaticSiteStorageAccount --resource-group $ResourceGroup --query "primaryEndpoints.web" --output tsv

Write-Host "Complete"