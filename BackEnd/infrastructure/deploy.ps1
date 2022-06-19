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
# Login
Write-Host "Login"

$username = $(username)
$password =$(pwd)

$SecurePassword = ConvertTo-SecureString $password -AsPlainText -Force

$credentials = New-Object System.Management.Automation.PSCredential($username, $SecurePassword)

Login-AzAccount -Credential $credentials

Write-Host "Deploy to $pathtozip"

#azdevopsautomecicd.zip
az webapp deploy --name $WebAppName --resource-group $ResourceGroup --src-path $pathtozip --type zip
az webapp start --name $WebAppName --resource-group $ResourceGroup