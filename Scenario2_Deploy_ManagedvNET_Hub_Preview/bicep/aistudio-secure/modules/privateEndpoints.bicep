param privateEndpointName string
param vnetId string
param vnetName string
param pepSubnetId string
param amlWorkspaceId string
param location string

// Create the private endpoint
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: pepSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'workspace'
        properties: {
          privateLinkServiceId: amlWorkspaceId
          groupIds: [
            'amlworkspace'
          ]
        }
      }
    ]
  }
}

// Create the private DNS zone
resource azuremlPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.api.azureml.ms'
  location: 'global'
  properties: {}
}

resource notebooksPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.notebooks.azure.net'
  location: 'global'
  properties: {}
}

// Link the DNS zone to the virtual network
resource azuremlVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${vnetName}-azureml-link'
  parent: azuremlPrivateDnsZone
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
}

resource notebooksVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${vnetName}-notebooks-link'
  parent: notebooksPrivateDnsZone
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
}

// Create the DNS zone group
resource dnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: 'amlzonegroup'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink.api.azureml.ms'
        properties: {
          privateDnsZoneId: azuremlPrivateDnsZone.id
        }
      }
      {
        name: 'privatelink.notebooks.azure.net'
        properties: {
          privateDnsZoneId: notebooksPrivateDnsZone.id
        }
      }
    ]
  }
}
