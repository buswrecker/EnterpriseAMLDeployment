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
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: hostingMode
    publicNetworkAccess: publicNetworkAccess
  }
  tags: {}
  dependsOn: []
}

output searchId string = search.id
output searchName string = search.name
