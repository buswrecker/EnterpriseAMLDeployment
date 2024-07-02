PREFIX ?= mvaip
deployment:
	az deployment group create --name secureaistudio --resource-group secure-ai-studio --template-file infra/main.bicep --parameters prefix=$(PREFIX)

project:
	az deployment group create --name secureaistudioproject --resource-group secure-ai-studio --template-file infra/project.main.bicep
