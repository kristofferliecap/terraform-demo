# Set environment variables
$env:AZ_TENANT_ID = ""
$env:AZ_SUBSCRIPTION_ID = "" 
$env:ARM_USE_AZUREAD = "true"
$env:RESOURCE_GROUP_NAME = "demo-terraform"
$env:STORAGE_ACCOUNT_NAME = "demoterraformstate01"
$env:CONTAINER_NAME = "terraform"
$env:KEY = "terraform.tfstate"
$env:ENV = "dev"

# Run Terraform init
terraform init `
  -backend-config="resource_group_name=$env:RESOURCE_GROUP_NAME" `
  -backend-config="storage_account_name=$env:STORAGE_ACCOUNT_NAME" `
  -backend-config="container_name=$env:CONTAINER_NAME" `
  -backend-config="key=$env:KEY" `
  -backend-config="subscription_id=$env:AZ_SUBSCRIPTION_ID" `
  -backend-config="tenant_id=$env:AZ_TENANT_ID" `
  -reconfigure
