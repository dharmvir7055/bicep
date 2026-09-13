using './main.bicep'

param environment = 'dev'
param location = 'centralindia'

// param cosmosAccountName = 'cosmos-shared-dev'
// param cosmosDatabaseName = 'appdb-dev'
// param cosmosResourceGroup = 'rg-shared-data-dev'
// param cosmosSubscriptionId = '<your-sub-id>'

param app1KeyVaultName = 'kv-app1-dev'
param app1PlanName = 'plan-app1-dev'
param app1PlanSku = 'B1'
param app1PlanCapacity = 1
param app1AppServiceName = 'app-app1-dev'

param app2KeyVaultName = 'kv-app2-dev'
param app2PlanName = 'plan-app2-dev'
param app2PlanSku = 'B1'
param app2PlanCapacity = 1
param app2AppServiceName = 'app-app2-dev'
// param app2ContainerName = 'app2container-dev'
// param app2Throughput = 400
