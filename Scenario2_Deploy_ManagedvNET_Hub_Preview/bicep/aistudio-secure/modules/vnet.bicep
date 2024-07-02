param vnetName string
param location string
param tagValues object
param addressPrefixes array
param subnetName string
param subnetPrivateDnsResolverName string // for vpn purpose
param subnetPrefix string
param serviceEndpointsAll array = []

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }

    subnets: [
      {
        name: '${subnetName}-pep'
        properties: {
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          serviceEndpoints: serviceEndpointsAll
        }
      }
      {
        name: subnetPrivateDnsResolverName
        properties: {
          addressPrefix: '10.0.254.0/24'
          delegations: [
            {
              name: 'Microsoft.Network.dnsResolvers'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.255.0/24'
        }
      }
    ]
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output pepSubnetId string = vnet.properties.subnets[0].id
output privateDnsResolverSubnetId string = vnet.properties.subnets[1].id
output gatewaySubnetId string = vnet.properties.subnets[2].id
