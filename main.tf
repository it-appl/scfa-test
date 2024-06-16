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

#Create public IPs
resource "azurerm_public_ip" "scfapublicip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.scfarg.location
  resource_group_name = azurerm_resource_group.scfarg.name
  allocation_method   = "Dynamic"
  tags                = local.tags
}

#Create Network Security Group
resource "azurerm_network_security_group" "scfansg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.scfarg.location
  resource_group_name = azurerm_resource_group.scfarg.name
  tags                = local.tags
}


#Create Network Security Group rules
resource "azurerm_network_security_rule" "scfansgrule" {
  name                        = "AllowHTTP"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.scfarg.name
  network_security_group_name = azurerm_network_security_group.scfansg.name
}

#Create network interface
resource "azurerm_network_interface" "scfanic" {
  name                = var.network_nic_name
  location            = azurerm_resource_group.scfarg.location
  resource_group_name = azurerm_resource_group.scfarg.name

  ip_configuration {
    name                          = "scfanicipconfig"
    subnet_id                     = azurerm_subnet.scfasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.scfapublicip.id
  }
}

#Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "scfanicnsg" {
  network_interface_id      = azurerm_network_interface.scfanic.id
  network_security_group_id = azurerm_network_security_group.scfansg.id
}

#Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    #Generate a new ID only when a new resource group is defined
    resource_group_name = azurerm_resource_group.scfarg.name
  }
  byte_length = 8
}
resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}
resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}

#Create storage account for boot diagnostics
resource "azurerm_storage_account" "scfasta" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.scfarg.location
  resource_group_name      = azurerm_resource_group.scfarg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Create virtual machine
resource "azurerm_windows_virtual_machine" "scfademovm" {
  name                  = "${var.prefix}-vm"
  admin_username        = "scfademoadmin"
  admin_password        = random_password.password.result
  location              = azurerm_resource_group.scfarg.location
  resource_group_name   = azurerm_resource_group.scfarg.name
  network_interface_ids = [azurerm_network_interface.scfanic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "scfaosdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.scfasta.primary_blob_endpoint
  }
}

#Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "scfawebserver" {
  name                       = "${random_pet.prefix.id}-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.scfademovm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
 {
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
 }
SETTINGS
}