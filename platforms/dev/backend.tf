terraform {
	backend "azurerm" {
		resource_group_name  = "CODE-1"
		storage_account_name = "stterraformdev0001"
		container_name       = "tfstate"
		key                  = "platforms/dev/terraform.tfstate"
	}
}

