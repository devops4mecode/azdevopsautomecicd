. $PSScriptRoot\common.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$pathtozip
    )

Write-Host "Publishing WebApp..."
az webapp deploy --resource-group $ResourceGroup --name $WebAppName --src-path $pathtozip --type zip --async true
Write-Host "Starting WebApp..."
az webapp start --name $WebAppName --resource-group $ResourceGroup