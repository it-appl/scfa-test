terraform {
  backend "azurerm" {
    subscription_id      = "aa15b081-25a8-4172-b28e-47524ad96893"
    resource_group_name  = "cloud-shell-storage-westeurope"
    storage_account_name = "sascfademo"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}