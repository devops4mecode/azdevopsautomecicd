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

$pathtozip='$(System.DefaultWorkingDirectory)/_BackEnd-Build/webappzip/WebApplication1.zip'
#DemoWebAppWithCiCd.zip
# $ctx=Get-AzContext
Write-Host "Publishing WebApp..."
#az webapp deploy --resource-group $ResourceGroup --name $WebAppName --src-path $pathtozip --type zip --async true
Publish-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName -ArchivePath (Get-Item $pathtozip).FullName -Force
Write-Host "Starting WebApp..."
Start-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName
#az webapp start --name $WebAppName --resource-group $ResourceGroup
