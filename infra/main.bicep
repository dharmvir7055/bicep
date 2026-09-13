@description('Environment name: dev, test, or prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string

@description('Azure region for resources')
param location string = resourceGroup().location

// // ===== Existing Cosmos DB (shared) =====
// param cosmosAccountName string
// param cosmosDatabaseName string
// param cosmosResourceGroup string = resourceGroup().name
// param cosmosSubscriptionId string = subscription().subscriptionId

// ===== App 1 =====
param app1KeyVaultName string
param app1PlanName string
param app1PlanSku string = 'B1'
param app1PlanCapacity int = 1
param app1AppServiceName string
param app1LinuxFxVersion string = 'DOTNET|8.0'

// ===== App 2 =====
param app2KeyVaultName string
param app2PlanName string
param app2PlanSku string = 'B1'
param app2PlanCapacity int = 1
param app2AppServiceName string
param app2LinuxFxVersion string = 'DOTNET|8.0'
// param app2ContainerName string
// param app2PartitionKeyPath string = '/id'
//@description('Throughput for App 2 container. Set to 0 if the DB uses shared throughput.')
//@minValue(0)
// param app2Throughput int = 400

// ================================================================
// App 1
// ================================================================
module app1Kv 'modules/keyvault.bicep' = {
  name: 'app1Kv-${environment}'
  params: {
    keyVaultName: app1KeyVaultName
    location: location
  }
}

module app1Plan 'modules/appservice-plan.bicep' = {
  name: 'app1Plan-${environment}'
  params: {
    planName: app1PlanName
    location: location
    skuName: app1PlanSku
    capacity: app1PlanCapacity
  }
}

module app1App 'modules/appservice.bicep' = {
  name: 'app1App-${environment}'
  params: {
    appServiceName: app1AppServiceName
    location: location
    planId: app1Plan.outputs.planId
    keyVaultUri: app1Kv.outputs.keyVaultUri
    keyVaultId: app1Kv.outputs.keyVaultId
    environment: environment
    linuxFxVersion: app1LinuxFxVersion
  }
}

// ================================================================
// App 2
// ================================================================
module app2Kv 'modules/keyvault.bicep' = {
  name: 'app2Kv-${environment}'
  params: {
    keyVaultName: app2KeyVaultName
    location: location
  }
}

module app2Plan 'modules/appservice-plan.bicep' = {
  name: 'app2Plan-${environment}'
  params: {
    planName: app2PlanName
    location: location
    skuName: app2PlanSku
    capacity: app2PlanCapacity
  }
}

module app2App 'modules/appservice.bicep' = {
  name: 'app2App-${environment}'
  params: {
    appServiceName: app2AppServiceName
    location: location
    planId: app2Plan.outputs.planId
    keyVaultUri: app2Kv.outputs.keyVaultUri
    keyVaultId: app2Kv.outputs.keyVaultId
    environment: environment
    linuxFxVersion: app2LinuxFxVersion
  }
}

// module app2Container 'modules/cosmos-container.bicep' = {
//   name: 'app2Container-${environment}'
//   params: {
//     cosmosAccountName: cosmosAccountName
//     databaseName: cosmosDatabaseName
//     cosmosResourceGroup: cosmosResourceGroup
//     cosmosSubscriptionId: cosmosSubscriptionId
//     containerName: app2ContainerName
//     partitionKeyPath: app2PartitionKeyPath
//     throughput: app2Throughput
//   }
// }

// ================================================================
// Outputs
// ================================================================
output app1AppServiceName string = app1App.outputs.appServiceName
output app2AppServiceName string = app2App.outputs.appServiceName
//output app2ContainerId string = app2Container.outputs.containerId
