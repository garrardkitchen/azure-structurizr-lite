<#
.SYNOPSIS
Deploy infra that hosts FOSS Structurizr lite product (www.c4model.com)

.PARAMETER -resourceGroup
Resource Group of where to deploy resources to

.PARAMETER -storageAccountName
The name to give the Storaage Account where a sample model dsl will be uploaded

.PARAMETER -appServiceName
The name to give to the App Service
#>

[CmdletBinding()]
param 
(
    [Parameter()]
    [string]
    $resourceGroup = "rg-structurizr",
    [Parameter()]
    [string]
    $storageAccountName = "c4docsdev2",
    [Parameter()]
    [string]
    $appServiceName = "structurizr-docs2"
    )

$ErrorActionPreference = "Stop"

# az-login
# Connect-AzAccount

New-AzResourceGroup -Name $resourceGroup -Location uksouth -Force

####################
# Validate/lint
####################

# az deployment group validate --resource-group $resourceGroup --template-file ./infra/main.bicep --parameters webName=$appServiceName saName=$storageAccountName    
$validation=(Test-AzResourceGroupDeployment -ResourceGroupName $resourceGroup  -TemplateFile ./infra/main.bicep -webName $appServiceName -saName $storageAccountName)

if ($validation -ne $null) {
    # failure here could be due to duplicate global resource name for SA or App Service
    $validation
    exit
}

####################
# What if
####################

try {
    #az deployment group what-if --resource-group $resourceGroup --template-file ./infra/main.bicep --parameters webName=$appServiceName saName=storageAccountName    
    New-AzResourceGroupDeployment -WhatIf -ResourceGroupName $resourceGroup -TemplateFile ./infra/main.bicep -webName $appServiceName -saName $storageAccountName
}
catch {
    throw  
}

####################
# Deploy
####################

try {
    #az deployment group create --resource-group $resourceGroup --template-file ./infra/main.bicep --parameters webName=$appServiceName saName=$storageAccountName    
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile ./infra/main.bicep -webName $appServiceName -saName $storageAccountName
}
catch {
    throw
}

####################
# Upload sample file
####################

# https://learn.microsoft.com/en-us/cli/azure/storage/file?view=azure-cli-latest#az-storage-file-upload

#$connectionString=$(az storage account show-connection-string --resource-group $resourceGroup -n $storageAccountName --query connectionString -o tsv )
#az storage file upload --connection-string $connectionString --path 'workspace.dsl' --share-name demo --source './workspace.dsl'

# https://learn.microsoft.com/en-us/powershell/module/az.storage/set-azstoragefilecontent?view=azps-10.2.0

Write-Output "Uploading file: workspace.dsl"
$uploadstorage = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
Set-AzStorageFileContent -ShareName "demo" -Source "structurizr/workspace.dsl" -Path "workspace.dsl" -Context $uploadstorage.Context -Force
Write-Output "Uploaded file: workspace.dsl"
