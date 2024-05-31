# Enterprise Deployment of AzureML and Azure AI Studio

This repository aims to provide guidance on the optimal deployment of AzureML and Azure AI Studio in an enterprise environment. By following the best practices outlined here, organizations can ensure a successful and efficient deployment of these powerful tools.


# Options for Enterprise customers

There are only 2 options for customers who choose to deploy AzureML / AI Studio into the enterprise

1. BYO vNET
    - This is sometimes known as legacy - was the primary method to deploy AML into network isolated environments
    - Often requires an existing vNET (vNET controlled by Azure Administrators)

2. Managed vNET + Workspace Hubs
    - This is the newest offering from Azure ML/AI Studio - allows you deploy network isolated AML/AI Studio in a vNET that is managed by Microsoft
    - Provides limited controls, but simplifies and speeds up deployment considerably

# Summary of Differences

| BYO vNET | Managed vNET |
|----------|--------------|
| Applies only to AzureML | Applies to AzureML & AI Studio |
| Full customization of vNET, subnets, firewalls, custom DNS, etc | Limited controls - Only modifications to FQDN, additional service tags, and PEs are allowed. |
| Time-consuming - ClickOps not recommended | Easy to set up - ClickOps possible |
| Ability to use on-prem data sources through Private Endpoint | Data must be in Azure - No PE support at the moment |
| Ability to call internal APIs | Only through FQDN - routed through public internet |
| Limited functionality with newer features, e.g., Workspace Hubs, Model Catalog, etc | Full functionality of the latest features in AML/AI Studio |
| Cost - predictable | Cost - FQDNs can be expensive - WorkspaceHubs can optimize this |


# Credits
- Meera Kurup
- Dennis Eikelenboom
- Mutaz Abu Ghazaleh
- Adarsh Jankiraman
- Setu Chokshi
- Eyas Taifour