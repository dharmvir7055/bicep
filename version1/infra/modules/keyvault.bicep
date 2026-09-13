@description('Name of the Key Vault')
param keyVaultName string

@description('Azure region for the Key Vault')
param location string = resourceGroup().location

@description('SKU name: standard or premium')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Tenant ID for the Key Vault')
param tenantId string = subscription().tenantId

@description('Access policies array (optional)')
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: tenantId
    accessPolicies: accessPolicies
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    publicNetworkAccess: 'Enabled'
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
