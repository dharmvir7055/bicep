// =============================================================
// App2 - main.bicep
// Creates Key Vault + App Service Plan + App Service,
// plus a new container inside an EXISTING shared Cosmos DB.
// =============================================================

targetScope = 'resourceGroup'

@description('Azure region')
param location string

@description('Name of the Key Vault for App2')
param keyVaultName string

@description('Name of the App Service Plan for App2')
param planName string

@description('SKU for the App Service Plan')
param planSku string = 'B1'

@description('Capacity for the App Service Plan')
param planCapacity int = 1

@description('Name of the App Service for App2')
param appServiceName string

@description('Runtime stack')
param linuxFxVersion string = 'DOTNET|8.0'

@description('Environment tag')
param environmentTag string

// -------- Existing Cosmos DB (shared) --------
// @description('Name of the existing Cosmos DB account')
// param cosmosAccountName string

// @description('Name of the existing database')
// param cosmosDatabaseName string

// @description('Resource group of the existing Cosmos DB account')
// param cosmosResourceGroup string

// @description('Subscription ID of the existing Cosmos DB account')
// param cosmosSubscriptionId string

// @description('Name of the new container')
// param containerName string

// @description('Partition key path')
// param partitionKeyPath string = '/id'

// @description('Throughput for the container (RU/s). 0 = use shared DB throughput.')
// @minValue(0)
// param throughput int = 400

module kv '../../../modules/keyvault.bicep' = {
  name: 'app2Kv-${environmentTag}'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

module plan '../../../modules/appservice-plan.bicep' = {
  name: 'app2Plan-${environmentTag}'
  params: {
    planName: planName
    location: location
    skuName: planSku
    capacity: planCapacity
  }
}

module app '../../../modules/appservice.bicep' = {
  name: 'app2App-${environmentTag}'
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

// module container '../../../modules/cosmos-container.bicep' = {
//   name: 'app2Container-${environmentTag}'
//   params: {
//     cosmosAccountName: cosmosAccountName
//     databaseName: cosmosDatabaseName
//     cosmosResourceGroup: cosmosResourceGroup
//     cosmosSubscriptionId: cosmosSubscriptionId
//     containerName: containerName
//     partitionKeyPath: partitionKeyPath
//     throughput: throughput
//   }
// }

output appServiceName string = app.outputs.appServiceName
//output containerName string = container.outputs.containerName
