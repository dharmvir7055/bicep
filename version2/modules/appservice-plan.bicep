@description('App Service Plan name')
param planName string

@description('Azure region')
param location string = resourceGroup().location

@description('SKU name (e.g., B1, P1v3)')
param skuName string = 'B1'

@description('Number of workers')
@minValue(1)
param capacity int = 1

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: location
  sku: {
    name: skuName
    capacity: capacity
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

output planId string = plan.id
output planName string = plan.name
