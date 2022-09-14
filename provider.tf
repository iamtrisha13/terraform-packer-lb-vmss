terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.22.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "trisha-rg"
    storage_account_name = "trishaterraform1302"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}



provider "azurerm" {
  features {

  }
}

provider "random" {
  
}