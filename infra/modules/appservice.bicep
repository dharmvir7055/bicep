@description('App Service name (globally unique)')
param appServiceName string

@description('Azure region')
param location string = resourceGroup().location

@description('ID of the App Service Plan')
param planId string

@description('Key Vault URI (for app setting)')
param keyVaultUri string

@description('Key Vault resource ID (for RBAC grant)')
param keyVaultId string

@description('Environment: dev, test, prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string

@description('Runtime stack (e.g., DOTNET|8.0, NODE|20-lts)')
param linuxFxVersion string = 'DOTNET|8.0'

var aspnetEnv = environment == 'prod' ? 'Production' : environment

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: planId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'KeyVaultUri'
          value: keyVaultUri
        }
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: aspnetEnv
        }
      ]
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: split(keyVaultId, '/')[8]
}

resource kvSecretsUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVaultId, appService.id, 'kv-secrets-user')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    )
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output appServiceId string = appService.id
output appServiceName string = appService.name
output principalId string = appService.identity.principalId
