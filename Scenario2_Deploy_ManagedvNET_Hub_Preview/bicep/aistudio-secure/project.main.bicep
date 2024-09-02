// global
param location string = resourceGroup().location
@description('The name of the AI Studio Hub Resource')
param hubName string
@description('The name of the Key Vault to access')
param keyVaultName string
param tags object = {}

@description('The configuration file containing Project details.')
param projectConfig object
@description('The SKU name to use for the AI Studio Hub Resource')
param skuName string = 'Basic'
@description('The SKU tier to use for the AI Studio Hub Resource')
@allowed(['Basic', 'Free', 'Premium', 'Standard'])
param skuTier string = 'Basic'
@description('The public network access setting to use for the AI Studio Hub Resource')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Disabled'

resource hub 'Microsoft.MachineLearningServices/workspaces@2024-01-01-preview' existing = {
  name: hubName
}

resource aiStudioProjects 'Microsoft.MachineLearningServices/workspaces@2024-01-01-preview' = [
  for project in projectConfig.projects: {
    name: project.name
    location: location
    tags: tags
    sku: {
      name: skuName
      tier: skuTier
    }
    kind: 'Project'
    identity: {
      type: 'SystemAssigned'
    }
    properties: {
      friendlyName: project.displayName
      hbiWorkspace: false
      v1LegacyMode: false
      publicNetworkAccess: publicNetworkAccess
      hubResourceId: hub.id
    }
  }
]

module keyVaultAccess 'modules/keyVaultAccess.bicep' = [
  for (project, i) in projectConfig.projects: {
    name: 'keyvault-access-${i}'
    params: {
      keyVaultName: keyVaultName
      principalId: aiStudioProjects[i].identity.principalId
    }
    dependsOn: [
      aiStudioProjects[i]
    ]
  }
]

module mlServiceRoleDataScientists 'modules/role.bicep' = [
  for (project, i) in projectConfig.projects: {
    name: 'ml-service-role-data-scientist-${i}'
    params: {
      principalId: aiStudioProjects[i].identity.principalId
      roleDefinitionId: 'f6c7c914-8db3-469d-8ca1-694a8f32e121'
      principalType: 'ServicePrincipal'
    }
    dependsOn: [
      aiStudioProjects[i]
    ]
  }
]

module mlServiceRoleSecretsReader 'modules/role.bicep' = [
  for (project, i) in projectConfig.projects: {
    name: 'ml-service-role-secrets-reader-${i}'
    params: {
      principalId: aiStudioProjects[i].identity.principalId
      roleDefinitionId: 'ea01e6af-a1c1-4350-9563-ad00f8c72ec5'
      principalType: 'ServicePrincipal'
    }
  }
]
