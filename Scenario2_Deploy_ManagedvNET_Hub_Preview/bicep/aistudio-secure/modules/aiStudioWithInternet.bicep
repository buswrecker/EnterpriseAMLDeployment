param tagValues object
param workspaceName string
param friendlyName string = workspaceName
param description string = ''
param location string
param kind string = 'Hub'
param identityType string = 'systemAssigned'
param primaryUserAssignedIdentityResourceGroup string = resourceGroup().name
param primaryUserAssignedIdentityName string = ''
var userAssignedIdentities = {
  '${primaryUserAssignedIdentity}': {}
}
var primaryUserAssignedIdentity = resourceId(
  primaryUserAssignedIdentityResourceGroup,
  'Microsoft.ManagedIdentity/userAssignedIdentities',
  primaryUserAssignedIdentityName
)
@allowed([
  'Basic'
  'Free'
  'Premium'
  'Standard'
])
param sku string = 'Basic'
param storageAccountId string
param keyVaultId string
@allowed([
  'new'
  'existing'
  'none'
])
param applicationInsightsOption string = 'none'
param applicationInsightsId string = ''
@allowed([
  'new'
  'existing'
  'none'
])
param containerRegistryOption string = 'none'
param containerRegistryId string = ''
param managedNetwork object = {
  isolationMode: 'AllowInternetOutbound'
}
param publicNetworkAccess string = 'Disabled'

param aiStudioService string
param aiSearchName string

// get resources details
resource aiStudioServiceResource 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: aiStudioService
}

resource search 'Microsoft.Search/searchServices@2021-04-01-preview' existing = if (!empty(aiSearchName)) {
  name: aiSearchName
}

resource workspace 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  tags: tagValues
  name: workspaceName
  location: location
  kind: kind
  identity: {
    type: identityType
    userAssignedIdentities: ((identityType == 'userAssigned') ? userAssignedIdentities : null)
  }
  sku: {
    tier: sku
    name: sku
  }
  properties: {
    friendlyName: friendlyName
    description: description
    storageAccount: storageAccountId
    keyVault: keyVaultId
    applicationInsights: ((applicationInsightsOption != 'none') ? applicationInsightsId : null)
    containerRegistry: ((containerRegistryOption != 'none') ? containerRegistryId : null)
    primaryUserAssignedIdentity: ((identityType == 'userAssigned') ? primaryUserAssignedIdentity : null)
    managedNetwork: managedNetwork
    publicNetworkAccess: publicNetworkAccess
  }
}

resource aiServiceConnection 'Microsoft.MachineLearningServices/workspaces/connections@2024-04-01' = {
  parent: workspace
  name: '${aiStudioService}-aiservice-connection'
  properties: {
    category: 'AIServices'
    authType: 'ApiKey'
    isSharedToAll: true
    target: aiStudioServiceResource.properties.endpoints['OpenAI Language Model Instance API']
    metadata: {
      ApiVersion: '2023-07-01-preview'
      ApiType: 'azure'
      ResourceId: aiStudioServiceResource.id
    }
    credentials: {
      key: aiStudioServiceResource.listKeys().key1
    }
  }
}

resource searchConnection 'Microsoft.MachineLearningServices/workspaces/connections@2024-04-01' = if (!empty(aiSearchName)) {
  parent: workspace
  name: '${aiSearchName}-connection'
  properties: {
    category: 'CognitiveSearch'
    authType: 'ApiKey'
    isSharedToAll: true
    target: 'https://${search.name}.search.windows.net/'
    credentials: {
      key: !empty(aiSearchName) ? search.listAdminKeys().primaryKey : ''
    }
  }
}

output workspaceId string = workspace.id
