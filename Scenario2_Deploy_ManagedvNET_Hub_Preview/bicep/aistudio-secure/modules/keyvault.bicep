param name string
param location string
param sku string = 'Standard'
param accessPolicies array = []
param tenant string
param enabledForDeployment bool = false
param enabledForTemplateDeployment bool = false
param enabledForDiskEncryption bool = false
param enableRbacAuthorization bool = true
param publicNetworkAccess string = 'Disabled'
param enableSoftDelete bool = true
param softDeleteRetentionInDays int = 90
param networkAcls object = {
  defaultAction: 'deny'
  bypass: 'AzureServices'
  ipRules: []
  virtualNetworkRules: []
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enableRbacAuthorization: enableRbacAuthorization
    accessPolicies: accessPolicies
    tenantId: tenant
    sku: {
      name: sku
      family: 'A'
    }
    publicNetworkAccess: publicNetworkAccess
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    networkAcls: networkAcls
  }
  tags: {}
  dependsOn: []
}

output keyVaultId string = keyvault.id
output keyVaultName string = keyvault.name
