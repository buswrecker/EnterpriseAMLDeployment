param location string
param gatewaySubnetId string
param privateDnsResolverSubnetId string
param publicIpName string
param vpnGatewayName string
param resolverName string
param vnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
}

// public ip address
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

// virtual network gateway
resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-11-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    vpnType: 'RouteBased'
    gatewayType: 'Vpn'
    enableBgp: false
    ipConfigurations: [
      {
        name: 'vpnGatewayIpConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: gatewaySubnetId
          }
        }
      }
    ]
  }
}

// dns private resolver
resource dnsPrivateResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: resolverName
  location: location
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
  }
  resource inboundEndpoints 'inboundEndpoints@2022-07-01' = {
    name: '${resolverName}-adpr-pep'
    location: location
    properties: {
      ipConfigurations: [
        {
          privateIpAllocationMethod: 'Dynamic'
          subnet: {
            id: privateDnsResolverSubnetId
          }
        }
      ]
    }
  }
}
