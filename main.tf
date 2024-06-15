resource "azurerm_resource_group" "scfarg" {
  name     = var.azure_rg_name
  location = var.azure_location

  tags = local.tags
}