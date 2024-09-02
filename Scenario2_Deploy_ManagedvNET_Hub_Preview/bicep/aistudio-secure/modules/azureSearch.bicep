param searchName string
param location string
param sku string = 'basic'
param hostingMode string = 'default'
param publicNetworkAccess string = 'Disabled'

resource search 'Microsoft.Search/searchServices@2024-03-01-preview' = {
  name: searchName
  location: location
  sku: {
    name: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    replicaCount: 1
    partitionCount: 1
    hostingMode: hostingMode
    publicNetworkAccess: publicNetworkAccess
    networkRuleSet: {
      bypass: 'AzureServices'
    }
  }
  tags: {}
  dependsOn: []
}

output searchId string = search.id
output searchName string = search.name
