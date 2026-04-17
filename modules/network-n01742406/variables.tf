variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "network_vnet_name" {
  type    = string
  default = "n01742406-VNET"
}

variable "network_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "network_subnet_name" {
  type    = string
  default = "n01742406-SUBNET"
}

variable "network_subnet_address_prefix" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "network_nsg_name" {
  type    = string
  default = "n01742406-NSG"
}