param aiStudioServiceName string
param searchName string
param storageAccountName string

// ############################################################
// roles based on https://review.learn.microsoft.com/en-us/azure/ai-studio/how-to/secure-data-playground?branch=pr-en-us-280529
// ############################################################

resource aiStudioService 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' existing = {
  name: aiStudioServiceName
}

resource searchService 'Microsoft.Search/searchServices@2024-03-01-preview' existing = {
  name: searchName
}

resource storageAccountBlob 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource roleAssignmentSearchIndexDataReaderAiStudioService 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: searchService
  name: guid(subscription().id, resourceGroup().id, aiStudioService.id, '1407120a-92aa-4202-b7e9-c0e197c71c8f')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '1407120a-92aa-4202-b7e9-c0e197c71c8f')
    principalId: aiStudioService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignmentSearchIndexDataContributorAiStudioService 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: searchService
  name: guid(subscription().id, resourceGroup().id, aiStudioService.id, '8ebe5a00-799e-43f5-93ac-243d3dce84a7')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7')
    principalId: aiStudioService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignmentSearchServiceContributorAiStudioService 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: searchService
  name: guid(subscription().id, resourceGroup().id, aiStudioService.id, '7ca78c08-252a-4471-8644-bb5ff32d4ba0')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0')
    principalId: aiStudioService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignmentStorageAccountBlobDataContributorAiStudioService 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: storageAccountBlob
  name: guid(subscription().id, resourceGroup().id, aiStudioService.id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: aiStudioService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignmentCognitiveServicesOpenAIContributorSrch 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: aiStudioService
  name: guid(subscription().id, resourceGroup().id, searchService.id, 'a001fd3d-188f-4b5d-821b-7da978bf7442')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'a001fd3d-188f-4b5d-821b-7da978bf7442')
    principalId: searchService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource roleAssignmentStorageAccountBlobDataContributorSrch 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: storageAccountBlob
  name: guid(subscription().id, resourceGroup().id, searchService.id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: searchService.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
