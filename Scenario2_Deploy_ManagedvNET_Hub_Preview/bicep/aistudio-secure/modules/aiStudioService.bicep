param name string
param location string
param sku string
param kind string
param publicNetworkAccess string

resource aiStudioService 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: kind
  properties: {
    customSubDomainName: name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: publicNetworkAccess
  }
}

output aiStudioServiceId string = aiStudioService.id
output aiStudioServiceName string = aiStudioService.name
