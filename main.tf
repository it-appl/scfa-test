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
}