// ##########################################
// Params
// ##########################################

// Global
@description('Deployment name - identifier')
param prefix string

@minLength(1)
@description('Primary location for all resources')
param location string = resourceGroup().location

@description('Tags for workspace, will also be populated if provisioning new dependent resources.')
param tagValues object = {}

var abbrs = loadJsonContent('abbreviations.json')
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 5)
var name = toLower('${prefix}')
var tenantId = subscription().tenantId

// VNET params
@description('Name of the VNet')
param vnetName string = ''

@description('Address prefix of the virtual network')
param addressPrefixes array = [
  '10.0.0.0/16'
]

@description('Name of the subnet')
param subnetName string = ''

@description('Subnet prefix of the virtual network')
param subnetPrefix string = '10.0.0.0/24'

var serviceEndpointsAll = [
  {
    service: 'Microsoft.Storage'
  }
  {
    service: 'Microsoft.KeyVault'
  }
  {
    service: 'Microsoft.ContainerRegistry'
  }
]

// keyvault params
param keyVaultName string = ''
param keyVaultSku string = 'standard'
param keyVaultAccessPolicies array = []

// ai studio service
param aiStudioSerivceName string = ''
param aiStudioSerivcesku string = 'S0'
param aiStudioSerivcekind string = 'AIServices'
param aiStudioSerivcepublicNetworkAccess string = 'Disabled'

// acr
param containerRegistryName string = ''
param zoneRedundancy string = 'disabled'
param containerRegistrySku string = 'Premium'
param acrPublicNetworkAccess string = 'Disabled'

// azure search
param searchName string = ''
param searchSku string = 'basic'
param hostingMode string = 'default'
param searchPublicNetworkAccess string = 'Disabled'

// storage
param storageAccountName string = ''
param storageSkuName string = 'Standard_LRS'

// ai studio
@description('Specifies the name of the Azure Machine Learning workspace.')
param aiStudioWorkspaceName string = ''
param aiStudioFriendlyName string = ''
param aiStudioDescription string = ''
@allowed([
  'Default'
  'FeatureStore'
  'Hub'
  'Project'
])
param aiStudioKind string = 'Hub'
@description('Specifies the identity type of the Azure Machine Learning workspace.')
@allowed([
  'systemAssigned'
  'userAssigned'
])
param aiStudioIdentityType string = 'systemAssigned'
@description('Specifies the sku, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Basic'
  'Free'
  'Premium'
  'Standard'
])
param aiStudioSku string = 'Basic'

@description('Determines whether or not new ApplicationInsights should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param applicationInsightsOption string = 'none'
param applicationInsightsId string = ''
@description('Determines whether or not a new container registry should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param aiStudioContainerRegistryOption string = 'new'
@description('Managed network settings to be used for the workspace. If not specified, isolation mode Disabled is the default')
param aiStudioManagedNetwork object = {
  isolationMode: 'AllowInternetOutbound'
}
@description('Specifies whether the workspace can be accessed by public networks or not.')
param aiStudioPublicNetworkAccess string = 'Disabled'

// private endpoints
param privateEndpointName string = ''

// compute instance
@description('Disables local auth when not using ssh')
param disableLocalAuth bool = true

@description('Specifies whether SSH access should be enabled for compute instance')
@allowed([
  'Disabled'
  'Enabled'
])
param sshAccess string = 'Disabled'

@description('Specifies the VM size of the Compute Instance to create under Azure Machine Learning workspace.')
@allowed([
  'A1_v2'
  'A2_v2'
  'A4_v2'
  'A8_v2'
  'A2m_v2'
  'A4m_v2'
  'A8m_v2'
  'Basic_A0'
  'Basic_A1'
  'Basic_A2'
  'Basic_A3'
  'Basic_A4'
  'Standard_A0'
  'Standard_A1'
  'Standard_A2'
  'Standard_A1_v2'
  'Standard_A2_v2'
  'Standard_A2m_v2'
  'Standard_A3'
  'Standard_A4'
  'Standard_A4_v2'
  'Standard_A4m_v2'
  'Standard_A5'
  'Standard_A6'
  'Standard_A7'
  'Standard_A8_v2'
  'Standard_A8m_v2'
  'Standard_D1'
  'Standard_D2'
  'Standard_D3'
  'Standard_D4'
  'Standard_D2_v3'
  'Standard_D4_v3'
  'Standard_D8_v3'
  'Standard_D16_v3'
  'Standard_D32_v3'
  'Standard_D64_v3'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32-16s_v3'
  'Standard_D32-8s_v3'
  'Standard_D32s_v3'
  'Standard_D64s_v3'
  'Standard_D64-32s_v3'
  'Standard_D64-16s_v3'
  'Standard_D1_v2'
  'Standard_D2_v2'
  'Standard_D2_v2_Promo'
  'Standard_D3_v2'
  'Standard_D3_v2_Promo'
  'Standard_D4_v2'
  'Standard_D4_v2_Promo'
  'Standard_D5_v2'
  'Standard_D5_v2_Promo'
  'Standard_DS1_v2'
  'Standard_DS2'
  'Standard_DS2_v2'
  'Standard_DS2_v2_Promo'
  'Standard_DS3'
  'Standard_DS3_v2'
  'Standard_DS3_v2_Promo'
  'Standard_DS4'
  'Standard_DS4_v2'
  'Standard_DS4_v2_Promo'
  'Standard_DS5'
  'Standard_DS5_v2'
  'Standard_DS5_v2_Promo'
  'Standard_B1ls'
  'Standard_B1ms'
  'Standard_B1s'
  'Standard_B2ms'
  'Standard_B2s'
  'Standard_B4ms'
  'Standard_B8ms'
  'Standard_D48_v3'
  'Standard_D48s_v3'
  'Standard_B12ms'
  'Standard_B16ms'
  'Standard_B20ms'
  'Standard_D2_v4'
  'Standard_D2d_v4'
  'Standard_D2ds_v4'
  'Standard_D4_v4'
  'Standard_D8_v4'
  'Standard_D16_v4'
  'Standard_D32_v4'
  'Standard_D32d_v4'
  'Standard_D32ds_v4'
  'Standard_D48_v4'
  'Standard_D64_v4'
  'Standard_D2s_v4'
  'Standard_D4s_v4'
  'Standard_D8s_v4'
  'Standard_D16s_v4'
  'Standard_D32s_v4'
  'Standard_D48s_v4'
  'Standard_D64s_v4'
  'Standard_D2as_v4'
  'Standard_D2a_v4'
  'Standard_D4as_v4'
  'Standard_D4a_v4'
  'Standard_D4d_v4'
  'Standard_D4ds_v4'
  'Standard_D8as_v4'
  'Standard_D8a_v4'
  'Standard_D8ds_v4'
  'Standard_D8d_v4'
  'Standard_D16a_v4'
  'Standard_D16as_v4'
  'Standard_D16d_v4'
  'Standard_D16ds_v4'
  'Standard_D32a_v4'
  'Standard_D32as_v4'
  'Standard_D48a_v4'
  'Standard_D48as_v4'
  'Standard_D48d_v4'
  'Standard_D48ds_v4'
  'Standard_D64a_v4'
  'Standard_D64as_v4'
  'Standard_D64d_v4'
  'Standard_D64ds_v4'
  'Standard_D96a_v4'
  'Standard_D96as_v4'
  'Experimental_D2ns_v4'
  'Experimental_D4ns_v4'
  'Experimental_D8ns_v4'
  'Experimental_D16ns_v4'
  'Experimental_D32ns_v4'
  'Experimental_D48ns_v2'
  'Experimental_D64ns_v2'
  'Standard_A8'
  'Standard_A9'
  'Standard_A10'
  'Standard_A11'
  'Standard_F1'
  'Standard_F2'
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_F1s'
  'Standard_F2s'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_F64s_v2'
  'Standard_F72s_v2'
  'Standard_F48s_v2'
  'Experimental_F2ns_v2'
  'Experimental_F4ns_v2'
  'Experimental_F8ns_v2'
  'Experimental_F16ns_v2'
  'Experimental_F32ns_v2'
  'Experimental_F48ns_v2'
  'Experimental_F64ns_v2'
  'Experimental_F72ns_v2'
  'Standard_D11'
  'Standard_D12'
  'Standard_D13'
  'Standard_D14'
  'Standard_E2_v3'
  'Standard_E4_v3'
  'Standard_E80ids_v4'
  'Standard_E80is_v4'
  'Standard_E8_v3'
  'Standard_E16_v3'
  'Standard_E32_v3'
  'Standard_E64_v3'
  'Standard_E64i_v3'
  'Standard_E2s_v3'
  'Standard_E4s_v3'
  'Standard_E4-2as_v4'
  'Standard_E4-2ds_v4'
  'Standard_E4-2s_v3'
  'Standard_E8s_v3'
  'Standard_E8-4as_v4'
  'Standard_E8-4ds_v4'
  'Standard_E8-4s_v3'
  'Standard_E8-2as_v4'
  'Standard_E8-2ds_v4'
  'Standard_E8-2d_v4'
  'Standard_E8-2s_v3'
  'Standard_E16s_v3'
  'Standard_E16-8as_v4'
  'Standard_E16-8ds_v4'
  'Standard_E16-8s_v3'
  'Standard_E16-4as_v4'
  'Standard_E16-4ds_v4'
  'Standard_E16-4s_v3'
  'Standard_E20_v3'
  'Standard_E20s_v3'
  'Standard_E32s_v3'
  'Standard_E32-16as_v4'
  'Standard_E32-16ds_v4'
  'Standard_E32-16s_v3'
  'Standard_E32-8as_v4'
  'Standard_E32-8ds_v4'
  'Standard_E32-8s_v3'
  'Standard_E64s_v3'
  'Standard_E64is_v3'
  'Standard_E64-32as_v4'
  'Standard_E64-32ds_v4'
  'Standard_E64-32s_v3'
  'Standard_E64-16s_v3'
  'Standard_D11_v2'
  'Standard_D11_v2_Promo'
  'Standard_D12_v2'
  'Standard_D12_v2_Promo'
  'Standard_D13_v2'
  'Standard_D13_v2_Promo'
  'Standard_D14_v2_Promo'
  'Standard_D14_v2'
  'Standard_D15_v2'
  'Standard_DS11'
  'Standard_DS11_v2'
  'Standard_DS11_v2_Promo'
  'Standard_DS11-1_v2'
  'Standard_DS12'
  'Standard_DS12_v2'
  'Standard_DS12_v2_Promo'
  'Standard_DS12-1_v2'
  'Standard_DS12-2_v2'
  'Standard_DS13'
  'Standard_DS13_v2'
  'Standard_DS13_v2_Promo'
  'Standard_DS13-2_v2'
  'Standard_DS13-4_v2'
  'Standard_DS14'
  'Standard_DS14_v2'
  'Standard_DS14_v2_Promo'
  'Standard_DS14-8_v2'
  'Standard_DS14-4_v2'
  'Standard_DS15_v2'
  'Special_CCX_DS13_v2'
  'Special_CCX_DS14_v2'
  'Standard_G1'
  'Standard_G2'
  'Standard_G3'
  'Standard_G4'
  'Standard_G5'
  'Standard_GS1'
  'Standard_GS2'
  'Standard_GS3'
  'Standard_GS4'
  'Standard_GS4-8'
  'Standard_GS4-4'
  'Standard_GS5'
  'Standard_GS5-16'
  'Standard_GS5-8'
  'Standard_M8ms'
  'Standard_M8-4ms'
  'Standard_M8-2ms'
  'Standard_M16ms'
  'Standard_M16-8ms'
  'Standard_M16-4ms'
  'Standard_M32ms'
  'Standard_M32-16ms'
  'Standard_M32-8ms'
  'Standard_M64'
  'Standard_M64m'
  'Standard_M64s'
  'Standard_M64ms'
  'Standard_M64-32ms'
  'Standard_M64-16ms'
  'Standard_M128'
  'Standard_M128m'
  'Standard_M128s'
  'Standard_M128ms'
  'Standard_M128-64ms'
  'Standard_M128-32ms'
  'Standard_M64ls'
  'Standard_M32ls'
  'Standard_M32ts'
  'Standard_E32-16_v3'
  'Standard_E32-8_v3'
  'Standard_E64-32_v3'
  'Standard_E64-16_v3'
  'Standard_D32-16_v3'
  'Standard_D32-8_v3'
  'Standard_D64-32_v3'
  'Standard_D64-16_v3'
  'Standard_E48_v3'
  'Standard_E48s_v3'
  'Standard_M416-208ms_v2'
  'Standard_M416-208s_v2'
  'Standard_M416s_v2'
  'Standard_M416ms_v2'
  'Standard_M208s_v2'
  'Standard_M208ms_v2'
  'Standard_D15i_v2'
  'Standard_DS15i_v2'
  'Standard_E2_v4'
  'Standard_E4_v4'
  'Standard_E8_v4'
  'Standard_E16_v4'
  'Standard_E20_v4'
  'Standard_E32_v4'
  'Standard_E48_v4'
  'Standard_E64_v4'
  'Standard_E2s_v4'
  'Standard_E4s_v4'
  'Standard_E8s_v4'
  'Standard_E16s_v4'
  'Standard_E20s_v4'
  'Standard_E32s_v4'
  'Standard_E48s_v4'
  'Standard_E64s_v4'
  'Standard_E64is_v4_SPECIAL'
  'Standard_E4-2s_v4'
  'Standard_E8-4s_v4'
  'Standard_E8-2s_v4'
  'Standard_E16-8s_v4'
  'Standard_E16-4s_v4'
  'Standard_E32-16s_v4'
  'Standard_E32-8s_v4'
  'Standard_E64-32s_v4'
  'Standard_E64-16as_v4'
  'Standard_E64-16ds_v4'
  'Standard_E64-16s_v4'
  'Standard_E2as_v4'
  'Standard_E2a_v4'
  'Standard_E2ds_v4'
  'Standard_E2d_v4'
  'Standard_E4as_v4'
  'Standard_E4d_v4'
  'Standard_E4ds_v4'
  'Standard_E4a_v4'
  'Standard_E8as_v4'
  'Standard_E8d_v4'
  'Standard_E8ds_v4'
  'Standard_E8a_v4'
  'Standard_E16as_v4'
  'Standard_E16a_v4'
  'Standard_E16d_v4'
  'Standard_E16ds_v4'
  'Standard_E20as_v4'
  'Standard_E20a_v4'
  'Standard_E20d_v4'
  'Standard_E20ds_v4'
  'Standard_E32as_v4'
  'Standard_E32d_v4'
  'Standard_E32ds_v4'
  'Standard_E32a_v4'
  'Standard_E48a_v4'
  'Standard_E48as_v4'
  'Standard_E48d_v4'
  'Standard_E48ds_v4'
  'Standard_E64a_v4'
  'Standard_E64as_v4'
  'Standard_E64d_v4'
  'Standard_E64ds_v4'
  'Standard_E96-24as_v4'
  'Standard_E96-48as_v4'
  'Standard_E96a_v4'
  'Standard_E96as_v4'
  'Experimental_E2ns_v4'
  'Experimental_E4ns_v4'
  'Experimental_E8ns_v4'
  'Experimental_E16ns_v4'
  'Experimental_E32ns_v4'
  'Experimental_E48ns_v4'
  'Experimental_E64ns_v4'
  'Standard_L4s'
  'Standard_L8s'
  'Standard_L16s'
  'Standard_L32s'
  'Standard_L8s_v2'
  'Standard_L16s_v2'
  'Standard_L32s_v2'
  'Standard_L64s_v2'
  'Standard_L48s_v2'
  'Standard_L80s_v2'
  'Standard_DC1s_v2'
  'Standard_DC2s_v2'
  'Standard_DC4s_v2'
  'Standard_DC8_v2'
  'Standard_NV6'
  'Standard_NV12'
  'Standard_NV24'
  'Standard_NC6'
  'Standard_NC12'
  'Standard_NC24'
  'Standard_NC24r'
  'Standard_NC6s_v2'
  'Standard_NC12s_v2'
  'Standard_NC24s_v2'
  'Standard_NC24rs_v2'
  'Standard_NC6s_v3'
  'Standard_NC12s_v3'
  'Standard_NC24s_v3'
  'Standard_NC24rs_v3'
  'Standard_ND6s'
  'Standard_ND12s'
  'Standard_ND24s'
  'Standard_ND24rs'
  'Standard_ND40s_v2'
  'Standard_NV6s_v2'
  'Standard_NV12s_v2'
  'Standard_NV24s_v2'
  'Standard_NV24_Promo'
  'Standard_NV12_Promo'
  'Standard_NV6_Promo'
  'Standard_NC24r_Promo'
  'Standard_NC24_Promo'
  'Standard_NC12_Promo'
  'Standard_NC6_Promo'
  'Standard_NV12s_v3'
  'Standard_NV24s_v3'
  'Standard_NV48s_v3'
  'Standard_ND40rs_v2'
  'Standard_NV4as_v4'
  'Standard_NV8as_v4'
  'Standard_NV16as_v4'
  'Standard_NV32as_v4'
  'Standard_NV24ms_v3'
  'Standard_NV32ms_v3'
  'Standard_NC4as_T4_v3'
  'Standard_NC8as_T4_v3'
  'Standard_NC16as_T4_v3'
  'Standard_NC64as_T4_v3'
  'Standard_H8'
  'Standard_H8m'
  'Standard_H16'
  'Standard_H16m'
  'Standard_H16r'
  'Standard_H16mr'
  'Standard_H16r_Promo'
  'Standard_H16mr_Promo'
  'Standard_H16m_Promo'
  'Standard_H16_Promo'
  'Standard_H8m_Promo'
  'Standard_H8_Promo'
  'Standard_HC44rs'
  'Standard_HB60rs'
  'Standard_HB120rs_v2'
])
param vmSize string = 'Standard_DS3_v2'

@description('Specifies who the compute is assigned to. Only they can access it.')
param assignedUserId string = 'c11b4b66-d260-4a64-b8aa-2b49fa379213'

@description('Specifies the tenant of the assigned user.')
param assignedUserTenant string = '16b3c013-d300-468d-ac64-7eda0820b6d3'

@description('Enable or disable node public IP address provisioning')
param enableNodePublicIp bool = false

// vpn
param deployVpnResources bool = false

// ##########################################
// Resources
// ##########################################

// VNET
module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: !empty(vnetName) ? vnetName : '${abbrs.virtualNetworks}${name}${uniqueSuffix}'
    location: location
    tagValues: tagValues
    addressPrefixes: addressPrefixes
    subnetName: !empty(subnetName) ? subnetName : '${abbrs.networkVirtualNetworksSubnets}${name}${uniqueSuffix}'
    subnetPrivateDnsResolverName: '${abbrs.networkPrivateDnsResolver}${name}${uniqueSuffix}' // for vpn purpose
    subnetPrefix: subnetPrefix
    serviceEndpointsAll: serviceEndpointsAll
  }
}

// Key Vault
module keyVault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    name: !empty(keyVaultName) ? keyVaultName : '${abbrs.keyVaultVaults}${name}${uniqueSuffix}'
    location: location
    sku: keyVaultSku
    accessPolicies: keyVaultAccessPolicies
    tenant: tenantId
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enableRbacAuthorization: false
    publicNetworkAccess: 'Disabled'
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    networkAcls: {
      defaultAction: 'deny'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

// AI Studio Service
module aiStudioService 'modules/aiStudioService.bicep' = {
  name: 'aiStudioService'
  params: {
    name: !empty(aiStudioSerivceName)
      ? aiStudioSerivceName
      : '${abbrs.cognitiveServicesAccounts}service-${name}${uniqueSuffix}'
    sku: aiStudioSerivcesku
    kind: aiStudioSerivcekind
    publicNetworkAccess: aiStudioSerivcepublicNetworkAccess
    location: location
  }
}

// ACR
module acr 'modules/acr.bicep' = {
  name: 'acr'
  params: {
    containerRegistryName: !empty(containerRegistryName)
      ? containerRegistryName
      : '${abbrs.containerRegistryRegistries}${name}${uniqueSuffix}'
    location: location
    tags: tagValues
    containerRegistrySku: containerRegistrySku
    publicNetworkAccess: acrPublicNetworkAccess
    zoneRedundancy: zoneRedundancy
  }
}

// Azure Search
module azureSearch 'modules/azureSearch.bicep' = {
  name: 'azureSearch'
  params: {
    searchName: !empty(searchName) ? searchName : '${abbrs.searchSearchServices}${name}${uniqueSuffix}'
    location: location
    sku: searchSku
    hostingMode: hostingMode
    publicNetworkAccess: searchPublicNetworkAccess
  }
}

// Azure Storage
module storage 'modules/storage.bicep' = {
  name: 'azureStorage'
  params: {
    location: location
    storageAccountName: !empty(storageAccountName)
      ? storageAccountName
      : '${abbrs.storageStorageAccounts}${name}${uniqueSuffix}'
    storageSkuName: storageSkuName
    tags: tagValues
  }
}

// AI Studio
module aiStudio 'modules/aiStudioWithInternet.bicep' = {
  name: 'aiStudio'
  params: {
    tagValues: tagValues
    workspaceName: !empty(aiStudioWorkspaceName)
      ? aiStudioWorkspaceName
      : '${abbrs.cognitiveServicesAccounts}${name}${uniqueSuffix}'
    friendlyName: aiStudioFriendlyName
    description: aiStudioDescription
    location: location
    kind: aiStudioKind
    identityType: aiStudioIdentityType
    sku: aiStudioSku
    storageAccountId: storage.outputs.storageAccountId
    keyVaultId: keyVault.outputs.keyVaultId
    applicationInsightsOption: applicationInsightsOption
    applicationInsightsId: applicationInsightsId
    containerRegistryOption: aiStudioContainerRegistryOption
    containerRegistryId: acr.outputs.registryId
    // systemDatastoresAuthMode: systemDatastoresAuthMode
    managedNetwork: aiStudioManagedNetwork
    publicNetworkAccess: aiStudioPublicNetworkAccess
    aiSearchName: azureSearch.outputs.searchName
    aiStudioService: aiStudioService.outputs.aiStudioServiceName
  }
}

// private endpoints
module privateEndpoints 'modules/privateEndpoints.bicep' = {
  name: 'privateEndpoints'
  params: {
    location: location
    vnetId: vnet.outputs.vnetId
    vnetName: vnet.outputs.vnetName
    pepSubnetId: vnet.outputs.pepSubnetId
    amlWorkspaceId: aiStudio.outputs.workspaceId
    privateEndpointName: !empty(privateEndpointName)
      ? privateEndpointName
      : '${abbrs.privateEndpoint}${name}${uniqueSuffix}'
  }
}

// compute instances to share across projects
module computeInstanceJuan 'modules/aiStudioComputeInstance.bicep' = {
  name: 'computeInstances'
  params: {
    workspaceName: aiStudio.name
    computeInstanceName: 'juanburckhardt3'
    location: location
    disableLocalAuth: disableLocalAuth
    sshAccess: sshAccess
    vmSize: vmSize
    assignedUserId: assignedUserId
    assignedUserTenant: assignedUserTenant
    enableNodePublicIp: enableNodePublicIp
  }
}

// not required for real env - just for testing - vpn=true
module vpnAccess 'modules/vpnAccess.bicep' = if (deployVpnResources) {
  name: 'vpnAccess'
  params: {
    location: location
    gatewaySubnetId: vnet.outputs.gatewaySubnetId
    privateDnsResolverSubnetId: vnet.outputs.privateDnsResolverSubnetId
    publicIpName: '${abbrs.networkPublicIPAddresses}${name}${uniqueSuffix}'
    vpnGatewayName: '${abbrs.networkVirtualNetworkGateways}${name}${uniqueSuffix}'
    resolverName: '${abbrs.networkPrivateDnsResolver}${name}${uniqueSuffix}'
    vnetName: vnet.outputs.vnetName
  }
}

// ##########################################
// Outputs
// ##########################################

// vent
output vnetId string = vnet.outputs.vnetId
output pepSubnetId string = vnet.outputs.pepSubnetId
// keyvault
output keyVaultId string = keyVault.outputs.keyVaultId
// ai studio service
output aiStudioServiceId string = aiStudioService.outputs.aiStudioServiceId
// acr
output registryName string = acr.outputs.registryName
output registryId string = acr.outputs.registryId
output registryUrl string = acr.outputs.registryUrl
// azure search
output searchId string = azureSearch.outputs.searchId
