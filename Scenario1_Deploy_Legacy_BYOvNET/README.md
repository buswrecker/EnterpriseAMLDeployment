# Scenario1 Deploy legacy BYOvNET

This folder contains the necessary files and instructions to deploy a Secure Network Isolated Azure Machine Learning (AzureML) workspace with Bring Your Own (BYO) virtual network (vNET).

## Prerequisites

Before deploying the AzureML workspace, make sure you have the following prerequisites:

- An Azure subscription
- Azure CLI installed on your local machine - version 2.61.0
- Azure CLI ML extension - version 2.26.1
## Deployment

To deploy the Secure Network Isolated AzureML workspace with BYO vNET, follow these steps:

1. Open a command prompt or terminal.

2. Navigate to the folder containing the deployment files.

3. Run the following command to initiate the deployment:


```
az deployment group create 
    --resource-group exampleRG 
    --template-file main.bicep 
    --parameters 
    prefix=prefix 
    dsvmJumpboxUsername=azureadmin 
    dsvmJumpboxPassword=securepassword
```

## References
Most of the latest Bicep templates for BYO are available at [Azure-QuickStart-Templates](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.machinelearningservices).