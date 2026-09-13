using './main.bicep'

param environment = 'test'
param location = 'eastus'

// param cosmosAccountName = 'cosmos-shared-test'
// param cosmosDatabaseName = 'appdb-test'
// param cosmosResourceGroup = 'rg-shared-data-test'
// param cosmosSubscriptionId = '<your-sub-id>'

param app1KeyVaultName = 'kv-app1-test'
param app1PlanName = 'plan-app1-test'
param app1PlanSku = 'B1'
param app1PlanCapacity = 1
param app1AppServiceName = 'app-app1-test'

param app2KeyVaultName = 'kv-app2-test'
param app2PlanName = 'plan-app2-test'
param app2PlanSku = 'B1'
param app2PlanCapacity = 1
param app2AppServiceName = 'app-app2-test'
// param app2ContainerName = 'app2container-test'
// param app2Throughput = 600
