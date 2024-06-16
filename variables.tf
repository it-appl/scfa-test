variable "azure_rg_name" {
  type        = string
  description = "The Azure RG Name"
  default     = "rg-scfa-udemy-demo"
}

variable "azure_location" {
  type        = string
  description = "The Azure Region"
  default     = "West Europe"
}

variable "virtual_network_name" {
  type        = string
  default     = "scfademovnet"
  description = "Name of virtual network"
}

variable "virtual_subnet_name" {
  default     = "scfademosubnet"
  description = "Name of the virtual subnet"
}

variable "public_ip_name" {
  default     = "scfademoip062024"
  description = "Name of the public ip"
}

variable "network_security_group_name" {
  default     = "scfademonsg"
  description = "Name of the network security group"
}

variable "network_nic_name" {
  default     = "scfademonic"
  description = "Name of the NIC"
}

variable "prefix" {
  type        = string
  default     = "win-iis"
  description = "Prefix of the resource name"
}