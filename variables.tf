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