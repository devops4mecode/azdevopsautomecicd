param(
    [Parameter(Mandatory=$true)]
    [string]$pathtozip
    )

. $PSScriptRoot\common.ps1

$ErrorActionPreference = "Stop" #this ensures that script stops executing at first error in the script.


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

Write-Host "Setting subscription for current session..."
az account set --subscription $subscription

# Write-Host "Creating resource group..."
# az group create --name $resourceGroup --location $location

# $webAppName="WelcomeCloudApp"  
# $appServicePlan="WelcomeCloudAppServicePlan"  

# Write-Host "Creating WebApp Service plan..."
# New-AzAppServicePlan  -Name $appServicePlan -ResourceGroupName $resourceGroup  -Location $location -Tier 'Free' #-Debug  

# Write-Host "Creating WebApp..."
# New-AzWebApp -Name $webAppName -Location $location -AppServicePlan $appServicePlan -ResourceGroupName $resourceGroup 

Write-Host "Publishing WebApp..."
Publish-AzWebApp -ResourceGroupName $resourceGroup -Name $webAppName -ArchivePath WelcomeCloudAppService.zip  

Write-Host "Finished installing your web app. Bye!"
