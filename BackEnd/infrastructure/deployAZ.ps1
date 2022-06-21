param(
    [Parameter(Mandatory=$true)]
    [string]$pathtozip
    )
$WebAppZIP=$pathtozip
. $PSScriptRoot\common.ps1

Write-Host "Publishing WebApp..."
az webapp deploy --resource-group $ResourceGroup --name $WebAppName --src-path $WebAppZIP --type zip --async true
Write-Host "Starting WebApp..."
az webapp start --name $WebAppName --resource-group $ResourceGroup