output "resource_group_name" {
  value = azurerm_resource_group.scfarg.name
}

output "public_ip_address" {
  value = azurerm_windows_virtual_machine.scfademovm.public_ip_address
}