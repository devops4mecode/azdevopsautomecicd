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
# $Location="southeastasia"
$Location="uksouth"
$ContainerForStaticContent="`$web"
$ResourceGroup="rg-demo-frontendwebsite-$environment"
$sku='Standard_LRS'
$StaticSiteStorageAccount="ddtuksouthstracc001$environment"
$errordoc="error.html"
$indexdoc="default.html"

Write-Host "Creating resource group $ResourceGroup at location $Location"
New-AzResourceGroup -Name $ResourceGroup  -Location $Location -Force


#az storage account create --name $StaticSiteStorageAccount --resource-group $ResourceGroup --location $Location --sku  --subscription $ctx.Subscription.Id

# Check for storage account and create if not found 
Write-Host "Check for  $StaticSiteStorageAccount and create if not found"  
$accstr = Get-AzureRmStorageAccount -Name $StaticSiteStorageAccount -ResourceGroupName $ResourceGroup -ErrorAction Ignore
if ($null -eq $accstr)  
{   
    Write-Host "Creating storage account $StaticSiteStorageAccount"
    New-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StaticSiteStorageAccount -Location $Location -SkuName $sku
}
Write-Host "Check for $ContainerForStaticContent and create if not found"  
$stoAccount=Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StaticSiteStorageAccount
$webContainer=Get-AzStorageContainer -Name $ContainerForStaticContent -Context $stoAccount.Context -ErrorAction Continue
if ($null -ne $webContainer){
    Write-Host "Deleting container $ContainerForStaticContent"
    Remove-AzStorageContainer -Name $ContainerForStaticContent -Context $stoAccount.Context -Force
}

Write-Host "Creating container $ContainerForStaticContent"
#az storage container create --name $ContainerForStaticContent --resource-group $ResourceGroup --account-name $StaticSiteStorageAccount | Out-Null
New-AzRmStorageContainer -ResourceGroupName $ResourceGroup -AccountName $StaticSiteStorageAccount -ContainerName $ContainerForStaticContent

Write-Host "Setting static web app properties"
#az storage blob service-properties update --account-name $StaticSiteStorageAccount --static-website --404-document "error.html" --index-document "default.html" | Out-Null
Enable-AzStorageStaticWebsite -IndexDocument $indexdoc -ErrorDocument404Path $errordoc

Write-Host "Purging existing files in container $ContainerForStaticContent"
#az storage blob delete-batch --account-name $StaticSiteStorageAccount --source $ContainerForStaticContent --pattern *.* 
# Get Storage Account Context
$straccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StaticSiteStorageAccount
$straccountcontext = $straccount.Context
Get-AzStorageBlob -Container '$web' -Blob * -Context $straccountcontext | Remove-AzStorageBlob

#pathhtml=$(System.DefaultWorkingDirectory)/_FrontEnd-Build/frontend-pages
$Sourcefolder=$pathhtml
Write-Host "Uploading files from $Sourcefolder"
#az storage blob upload-batch --account-name $StaticSiteStorageAccount --source $Sourcefolder -d '$web'
azcopy copy $Sourcefolder "https://$StaticSiteStorageAccount.blob.core.windows.net/$ContainerForStaticContent/"

Write-Host "Complete"
$acc=Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StaticSiteStorageAccount
Write-Host ("Endpoint of static site is {0}" -f $acc.PrimaryEndpoints.Web)