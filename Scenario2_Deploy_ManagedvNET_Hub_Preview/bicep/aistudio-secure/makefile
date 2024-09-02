PREFIX ?= mvaip
deployment:
	az deployment sub create --name aistudio-managed-vnet \
		--location eastus2 \
		--template-file infra/main.bicep \
		--parameters infra/main.bicepparam \
		--parameters prefix=$(PREFIX) \
		--parameters location=eastus2 \
		--parameters ciConfig=@infra/computeInstances.json
	az deployment sub show --name aistudio-managed-vnet --query properties.outputs > hub.output.json


project:
	az deployment sub show --name aistudio-managed-vnet --query properties.outputs > hub.output.json
	hubName=$$(jq -r '.hubName.value' hub.output.json); \
	kvName=$$(jq -r '.keyVaultName.value' hub.output.json); \
	rgName=$$(jq -r '.rgName.value' hub.output.json); \
	az deployment group create --name aistudio-managed-vnet-project \
		--resource-group $$rgName \
		--template-file infra/project.main.bicep \
		--parameters hubName=$$hubName \
		--parameters keyVaultName=$$kvName \
		--parameters projectConfig=@infra/aiStudioProjects.json
