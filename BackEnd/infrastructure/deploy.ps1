param(
    [Parameter(Mandatory=$true)]
    [string]$pathtozip
    )

. $PSScriptRoot\common.ps1

<#
What is the structure of the ZIP file?
--------------------------------------
The ZIP file should contain the assemblies at the very top level, i.e. not in any subfolder
How to publish?
---------------
dotnet publish  --configuration Release --output %temp%\DemoWebAppWithCiCd WebApplication1.csproj
#>

Write-Host "Deploy $pathtozip"
$pathtozip='$(System.DefaultWorkingDirectory)/_BackEnd-Build/webappzip/WebApplication1.zip'
#DemoWebAppWithCiCd.zip
# $ctx=Get-AzContext
az webapp deploy --name $WebAppName --resource-group $ResourceGroup --src-path $pathtozip --type zip
az webapp start --name $WebAppName --resource-group $ResourceGroup
# Write-Host "Publishing WebApp..."
# Publish-AzWebApp -ResourceGroupName $resourceGroup -Name $webAppName -ArchivePath $pathWebAppZip
# # az webapp start --name $WebAppName --resource-group $ResourceGroup  --subscription $ctx.Subscription.Id
# Write-Host "Starting WebApp..."
# Start-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName
