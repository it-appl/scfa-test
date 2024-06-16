terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  tenant_id       = "30a03c1d-8b9f-437d-9680-205575f91380"
  subscription_id = "aa15b081-25a8-4172-b28e-47524ad96893"
}