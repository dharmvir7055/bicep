using './main.bicep'

param environment = 'prod'
param location = 'eastus'

// param cosmosAccountName = 'cosmos-shared-prod'
// param cosmosDatabaseName = 'appdb-prod'
// param cosmosResourceGroup = 'rg-shared-data-prod'
// param cosmosSubscriptionId = '<your-sub-id>'

param app1KeyVaultName = 'kv-app1-prod'
param app1PlanName = 'plan-app1-prod'
param app1PlanSku = 'P1v3'
param app1PlanCapacity = 3
param app1AppServiceName = 'app-app1-prod'

param app2KeyVaultName = 'kv-app2-prod'
param app2PlanName = 'plan-app2-prod'
param app2PlanSku = 'P1v3'
param app2PlanCapacity = 3
param app2AppServiceName = 'app-app2-prod'
// param app2ContainerName = 'app2container-prod'
// param app2Throughput = 1000
