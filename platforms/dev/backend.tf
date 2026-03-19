terraform {
  backend "azurerm" {
    resource_group_name  = "CODE-1"
    storage_account_name = "sttfstatekekas001"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}