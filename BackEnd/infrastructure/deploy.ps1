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
dotnet publish  --configuration Release --output %temp%\azdevopsautomecicd WebApplication1.csproj
#>
#Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
#$pathWebAppZip= '_BackEnd-Build/webappzip/WebApplication1.zip'
Write-Host "Deploy to WebApp"

#azdevopsautomecicd.zip
#$ctx=Get-AzContext
# az webapp deploy --name $WebAppName --resource-group $ResourceGroup --src-path $pathtozip --type zip --subscription $ctx.Subscription.Id
#Publish-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName -ArchivePath $pathWebAppZip
$app = Get-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName
Publish-AzWebApp -WebApp $app -ArchivePath /_BackEnd-Build/webappzip/WebApplication1.zip -Timeout 300000 -Force
# az webapp start --name $WebAppName --resource-group $ResourceGroup  --subscription $ctx.Subscription.Id
Start-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName
