targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Location for the AI resource')
@allowed([
  'australiaeast'
  'swedencentral'
  'westus'
])
@metadata({
  azd: {
    type: 'location'
  }
})
param location string

@description('Name of the GPT model to deploy')
param gptModelName string = 'gpt-4o'
@description('Version of the GPT model to deploy')
param gptModelVersion string = '2024-08-06'
@description('Name of the model deployment (can be different from the model name)')
param gptDeploymentName string = 'gpt-4o'
@description('Capacity of the GPT deployment')
// You can increase this, but capacity is limited per model/region, so you will get errors if you go over
// https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
param gptDeploymentCapacity int = 30
@description('Name of the embedding model to deploy')
param embeddingModelName string = 'text-embedding-ada-002'
@description('Version of the embedding model to deploy')
param embeddingModelVersion string = '2'
@description('Name of the model deployment (can be different from the model name)')
param embeddingDeploymentName string = 'text-embedding-ada-002'
@description('Id of the user or app to assign application roles')
param principalId string = ''
@description('Non-empty if the deployment is running on GitHub Actions')
param runningOnGitHub string = ''

var principalType = empty(runningOnGitHub) ? 'User' : 'ServicePrincipal'

var uniqueId = toLower(uniqueString(subscription().id, environmentName, location))
var resourcePrefix = '${environmentName}${uniqueId}'
var tags = {
    'azd-env-name': environmentName
    owner: 'azure-ai-sample'
}

// Organize resources in a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
    name: '${resourcePrefix}-rg'
    location: location
    tags: tags
}

var aiServiceName = '${resourcePrefix}-aiservice'
module aiService 'br/public:avm/res/cognitive-services/account:0.8.1' = {
  name: 'aiService'
  scope: resourceGroup
  params: {
    name: aiServiceName
    location: location
    tags: tags
    kind: 'AIServices'
    sku: 'S0'
    customSubDomainName: aiServiceName
    restrictOutboundNetworkAccess: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    roleAssignments: [
        {
          principalId: principalId
          roleDefinitionIdOrName: 'Cognitive Services User'
          principalType: principalType
        }
      ]
  }
}

var openAiName = '${resourcePrefix}-openai'
module openAi 'br/public:avm/res/cognitive-services/account:0.8.1' = {
  name: 'openai'
  scope: resourceGroup
  params: {
    name: openAiName
    location: location
    tags: tags
    kind: 'OpenAI'
    sku: 'S0'
    customSubDomainName: openAiName
    restrictOutboundNetworkAccess: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    deployments: [
      {
        name: gptDeploymentName
        model: {
          format: 'OpenAI'
          name: gptModelName
          version: gptModelVersion
        }
        sku: {
          name: 'GlobalStandard'
          capacity: gptDeploymentCapacity
        }
      }
      {
        name: embeddingDeploymentName
        model: {
          format: 'OpenAI'
          name: embeddingModelName
          version: embeddingModelVersion
        }
        sku: {
          name: 'Standard'
          capacity: gptDeploymentCapacity
        }
      }
    ]
    roleAssignments: [
      {
        principalId: principalId
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
        principalType: principalType
      }
    ]
  }
}

var searchServiceName = '${resourcePrefix}-search'
module searchService './modules/azure-search.bicep' = {
  name: 'searchService'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    name: searchServiceName
  }
}

module searchRoleIndexContributor 'modules/role.bicep' = {
  scope: resourceGroup
  name: 'search-role-index-contributor'
  params: {
    principalId: principalId
    roleDefinitionId: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
    principalType: principalType
  }
}

module searchRoleContributor 'modules/role.bicep' = {
  scope: resourceGroup
  name: 'search-role-contributor'
  params: {
    principalId: principalId
    roleDefinitionId: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
    principalType: principalType
  }
}

output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_RESOURCE_GROUP string = resourceGroup.name
output AZURE_AI_SERVICE_ENDPOINT string = aiService.outputs.endpoint
output AZURE_OPENAI_ENDPOINT string = openAi.outputs.endpoint
output AZURE_OPENAI_CHAT_DEPLOYMENT_NAME string = gptDeploymentName
output AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME string = embeddingDeploymentName
output AZURE_SEARCH_ENDPOINT string = searchService.outputs.endpoint
