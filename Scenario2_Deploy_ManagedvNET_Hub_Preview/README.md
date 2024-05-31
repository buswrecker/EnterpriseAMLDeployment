# Scenario 2: Deploy Managed vNET for AzureML/AI Studio

## Description

This repository contains the necessary resources and instructions to deploy a Managed vNET for AzureML/AI Studio. The deployment scenario focuses on creating a secure and isolated network environment for your Azure Machine Learning and AI Studio workloads. This simple repository demonstrates how to set up a Workspace-Hub in a Managed vNET configuration specifically with Azure CLI / YML. 

## Prerequisites

Before you begin, ensure that you have the following prerequisites:

- An Azure subscription
- Azure CLI installed on your local machine - version 2.61.0
- Azure CLI ML extension - version 2.26.1

## Deployment Steps

Follow these steps to deploy the Managed vNET for AzureML/AI Studio:

```
az login
az group create --name WorkspaceHubManagedVNet --location australiaeast
az ml workspace create -f yml/DeployManagedvNET.yml --kind hub --resource-group WorkspaceHubManagedVNet
### Alternative with secured Dependencies
az ml workspace create -f yml/DeployManagedvNET-withDependencies.yml --kind hub --resource-group WorkspaceHubManagedVNet
```
Once the Hub has been created, log into the Azure AI Studio and proceed to create projects. 


