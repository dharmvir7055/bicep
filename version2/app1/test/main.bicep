// =============================================================
// App1 - main.bicep
// Reuses shared modules. Values come from parameters.json.
// =============================================================

targetScope = 'resourceGroup'

@description('Azure region')
param location string

@description('Name of the Key Vault for App1')
param keyVaultName string

@description('Name of the App Service Plan for App1')
param planName string

@description('SKU for the App Service Plan')
param planSku string = 'B1'

@description('Capacity for the App Service Plan')
param planCapacity int = 1

@description('Name of the App Service for App1')
param appServiceName string

@description('Runtime stack')
param linuxFxVersion string = 'DOTNET|8.0'

@description('Environment tag')
param environmentTag string

module kv '../../modules/keyvault.bicep' = {
  name: 'app1Kv-${environmentTag}'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

module plan '../../modules/appservice-plan.bicep' = {
  name: 'app1Plan-${environmentTag}'
  params: {
    planName: planName
    location: location
    skuName: planSku
    capacity: planCapacity
  }
}

module app '../../modules/appservice.bicep' = {
  name: 'app1App-${environmentTag}'
  params: {
    appServiceName: appServiceName
    location: location
    planId: plan.outputs.planId
    keyVaultUri: kv.outputs.keyVaultUri
    keyVaultId: kv.outputs.keyVaultId
    environment: environmentTag
    linuxFxVersion: linuxFxVersion
  }
}

output appServiceName string = app.outputs.appServiceName
