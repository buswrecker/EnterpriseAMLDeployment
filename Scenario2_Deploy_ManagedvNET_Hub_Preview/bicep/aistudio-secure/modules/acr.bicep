param containerRegistryName string
param location string
param zoneRedundancy string = 'disabled'
param containerRegistrySku string
param tags object
param publicNetworkAccess string = 'Disabled'

resource registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: containerRegistrySku
  }
  tags: tags
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
  }
}

output registryName string = registry.name
output registryId string = registry.id
output registryUrl string = registry.properties.loginServer
