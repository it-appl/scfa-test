resource "azurerm_resource_group" "scfarg" {
  name     = var.azure_rg_name
  location = var.azure_location

  tags = local.tags
}

#Create virtual network
resource "azurerm_virtual_network" "scfavnet" {
  name                = var.virtual_network_name
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.scfarg.location
  resource_group_name = azurerm_resource_group.scfarg.name
  tags                = local.tags
}

#Create subnet
resource "azurerm_subnet" "scfasubnet" {
  name                 = var.virtual_subnet_name
  resource_group_name  = azurerm_resource_group.scfarg.name
  virtual_network_name = azurerm_virtual_network.scfavnet.name
  address_prefixes     = ["10.30.1.0/24"]
}

