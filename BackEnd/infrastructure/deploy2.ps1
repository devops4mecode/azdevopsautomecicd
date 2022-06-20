. $PSScriptRoot\common.ps1

Write-Host "Publishing WebApp..."
az webapp deploy --resource-group $ResourceGroup --name $WebAppName --src-path $(pathtozip) --type zip --async true

az webapp start --name $WebAppName --resource-group $ResourceGroup