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

Write-Host "Deploy to $pathtozip"

#azdevopsautomecicd.zip
az webapp deploy --name $WebAppName --resource-group $ResourceGroup --src-path $pathtozip --type zip
az webapp start --name $WebAppName --resource-group $ResourceGroup