param(
    [Parameter(Mandatory=$true)]
    [string]$pathtozip
    )

. $PSScriptRoot\common.ps1
Write-host "Installing nuget package provider"
Install-PackageProvider -Name NuGet -Scope CurrentUser -MinimumVersion 2.8.5.201 -Force
Write-Host "Setting Power Shell gallery"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Write-Host "Installing missing PowerShell modules required for running this script.."
if ((Get-InstalledModule -Name "Az.Accounts" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "Az.Accounts module missing. Now installing..."
    Install-Module -Name Az.Accounts -Scope CurrentUser
}


if ((Get-InstalledModule -Name "Az.Websites" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Host "Az.Websites module missing. Now installing .."
    Install-Module -Name Az.Websites -Scope CurrentUser
}
Write-Host "Installing PowerShell modules completed."

Write-Host "Staring to import PowerShell modules in current session...."
Import-Module Az.websites
Write-Host "Importing PowerShell modules completed."


#This is required due to an issue due to which PowerShell fails to connect with online resources. This issue is machine specific. So you can comment it if not required.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "Connecting to Azure account..."
Connect-AzAccount

<#
What is the structure of the ZIP file?
--------------------------------------
The ZIP file should contain the assemblies at the very top level, i.e. not in any subfolder
How to publish?
---------------
dotnet publish  --configuration Release --output %temp%\azdevopsautomecicd WebApplication1.csproj
#>
#Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
$pathWebAppZip= '$(System.DefaultWorkingDirectory)/_BackEnd-Build/webappzip/WebApplication1.zip'
#$ctx=Get-AzContext
# az webapp deploy --name $WebAppName --resource-group $ResourceGroup --src-path $pathtozip --type zip --subscription $ctx.Subscription.Id
Write-Host "Publishing WebApp..."
Publish-AzWebApp -ResourceGroupName $resourceGroup -Name $webAppName -ArchivePath $pathWebAppZip
# az webapp start --name $WebAppName --resource-group $ResourceGroup  --subscription $ctx.Subscription.Id
Write-Host "Starting WebApp..."
Start-AzWebApp -ResourceGroupName $ResourceGroup -Name $WebAppName
