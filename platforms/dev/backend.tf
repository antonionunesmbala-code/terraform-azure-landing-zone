terraform {
	backend "azurerm" {
		resource_group_name  = "rg-tfstate-dev"
		storage_account_name = "stterraformdev0001"
		container_name       = "tfstate"
		key                  = "platforms/dev/terraform.tfstate"
	}
}

