@description('Name of the existing Cosmos DB account')
param cosmosAccountName string

@description('Name of the existing database inside the Cosmos DB account')
param databaseName string

@description('Name of the new container to create')
param containerName string

@description('Partition key path (e.g., /id)')
param partitionKeyPath string = '/id'

@description('Throughput (RU/s). Set to 0 if the database uses shared throughput.')
@minValue(0)
param throughput int = 400

@description('Resource group of the existing Cosmos DB account')
param cosmosResourceGroup string = resourceGroup().name

@description('Subscription ID of the existing Cosmos DB account')
param cosmosSubscriptionId string = subscription().subscriptionId

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' existing = {
  name: cosmosAccountName
  scope: resourceGroup(cosmosSubscriptionId, cosmosResourceGroup)
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' existing = {
  parent: cosmosAccount
  name: databaseName
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  parent: database
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          partitionKeyPath
        ]
        kind: 'Hash'
      }
    }
  }
}

resource throughputSettings 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/throughputSettings@2023-11-15' = if (throughput > 0) {
  parent: container
  name: 'default'
  properties: {
    resource: {
      throughput: throughput
    }
  }
}

output containerId string = container.id
output containerName string = container.name
